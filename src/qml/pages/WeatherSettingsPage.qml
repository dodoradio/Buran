/*
 * Copyright (C) 2018 - Florent Revest <revestflo@gmail.com>
 *               2016 - Andrew Branson <andrew.branson@jollamobile.com>
 *                      Ruslan N. Marchenko <me@ruff.mobi>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml.Models 2.15
import Qt.labs.settings 1.0


Pane {
    id: weatherSettings
    property var savedlocations: ""
    property int locationPrecision: 4

    Settings {
        category: "Locations"
        property alias savedlocations: weatherSettings.savedlocations
    }
    Component {
        id: dragDelegate

        MouseArea {
            id: dragArea

            property bool held: false

            anchors { left: parent.left; right: parent.right }
            height: content.height
            drag.target: held ? content : undefined
            drag.axis: Drag.YAxis

            onPressAndHold: {
                console.debug("held = true")
                held = true
            }
            onReleased: {
                console.debug("held = false")
                held = false
            }

            Rectangle {
                id: content
                anchors { 
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
                width: dragArea.width
                height: databox.implicitHeight + 4

                border.width: 1
                border.color: "lightsteelblue"

                color: dragArea.held ? "lightsteelblue" : "white"
                Behavior on color { ColorAnimation { duration: 100 } }

                radius: 2
                Drag.active: dragArea.held
                Drag.source: dragArea
                Drag.hotSpot.x: width / 2
                Drag.hotSpot.y: height / 2
                states: State {
                    when: dragArea.held

                    ParentChange { target: content; parent: listroot }
                    AnchorChanges {
                        target: content
                        anchors { horizontalCenter: undefined; verticalCenter: undefined }
                    }
                }

                Column {
                    id: databox
                    anchors { fill: parent; margins: 2 }

                    Label { 
                        id: loclabel
                        text: "<b>" + name + "</b>"
                    }
                    Text { 
                        text: qsTr('LAT: ') + lat 
                    }
                    Text { 
                        text: qsTr('LON: ') + lng 
                    }
                }
            }
            DropArea {
                anchors { fill: parent; margins: 10 }
                onEntered: {
                    locations.move(
                                drag.source.DelegateModel.itemsIndex,
                                dragArea.DelegateModel.itemsIndex,
                                1)
                }
            }
        }
    }

    ListModel {
        id: locations
    }

    DelegateModel {
        id: visualModel
        model: locations
        delegate: dragDelegate
    }


    Label {
        id: colLabel
        anchors.top: parent.top
        text: qsTr("Locations")
    }

    Rectangle {
        id: listroot
        anchors.top: colLabel.bottom
        anchors.bottom: addButton.top
        width: parent.width

        ListView {
            id: locList
            anchors.fill: parent
            anchors.margins: 2
            model: visualModel
            spacing: 4
        }
    }

    Button {
        id: addButton
        width: parent.width
        anchors.bottom: delButton.top
        topPadding: 4

        text: qsTr("Add Location")
        onClicked: {
            var zoomlat = locations.count ? parseFloat(locations.get(0).lat): 51.5
            var zoomlong = locations.count ? parseFloat(locations.get(0).lng): -0.144
            console.log("locations count = ", locations.count)
            console.log("zoomlat = ", zoomlat)
            console.log("zoomlong = ", zoomlong)
            var newloc = pageStack.push(Qt.resolvedUrl("LocationPicker.qml"), {lat:zoomlat, lon:zoomlong});
            newloc.activated.connect(selected)
            function selected(name, lat, lng) {
                newloc.activated.disconnect(selected);
                console.log(name, lat, lng);
                locations.append({"name":name,
                        "lat":lat.toFixed(locationPrecision).toString(),
                        "lng":lng.toFixed(locationPrecision).toString()} );
            }
        }
    }

    Button {
        id: delButton
        width: parent.width
        anchors.bottom: fetchButton.top
        topPadding: 4

        text: qsTr("Delete Bottom Location")
        onClicked: locations.remove(locations.count - 1)
    }

    Button {
        id: fetchButton
        text: qsTr("Fetch weather data")
        width: parent.width
        anchors.bottom: parent.bottom
        topPadding: 4
        onClicked: {
            watch.setWeatherCityName(locations.get(0).name)
            console.log("getting weather for ", locations.get(0).lat, ", ", locations.get(0).lng);
            getWeatherForecast(locations.get(0).lat, locations.get(0).lng)
        }
    }

    Component.onCompleted: {
        if (savedlocations) {
            locations.clear()
            var datamodel = JSON.parse(savedlocations)
            for (var i=0; i < datamodel.length; ++i) {
                locations.append(datamodel[i])
            }
        }
    }

    Component.onDestruction: {
        var datamodel = []
        for (var i = 0; i < locations.count; ++i) {
            datamodel.push(locations.get(i))
        }
        savedlocations = JSON.stringify(datamodel)
    }

    function getWeatherForecast(lat, lon) {
        const xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
            if (xhttp.readyState == XMLHttpRequest.DONE && xhttp.status == 200) {
                updateForecast(xhttp.responseText.toString());
            }
        };
        var APIkey = "36cc791575eef0fc1a4560ac24475dad";
        var omit = "current,minutely,hourly,alerts";
        var url = `https://api.openweathermap.org/data/2.5/onecall?lat=${lat}&lon=${lon}&exclude=${omit}&appid=${APIkey}`;
        console.log("url: ", url);
        xhttp.open("GET", url);
        xhttp.send();
    }

    function updateForecast(forecast) {
        watch.updateWeather(forecast)
    }
}

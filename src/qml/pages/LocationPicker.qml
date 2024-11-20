/*
 * Copyright (C) 2022 - Ed Beroset <github.com/beroset>
 * All rights reserved.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.2
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtPositioning 5.15
import QtLocation 6.8

Pane {
    id: root
    signal activated(string placename, real lat, real lon)
    property alias placename: thisplacename.text
    property real lat
    property real lon

    Plugin {
        id: mapPlugin
        name: "osm"
        PluginParameter {
            name: "osm.mapping.providersrepository.disabled"
            value: "true"
        }
        PluginParameter {
            name: "osm.mapping.providersrepository.address"
            value: "http://maps-redirect.qt.io/osm/5.15/"
        }
    }
    Column {
        anchors.fill: parent

        GridLayout {
            id: select
            columns: 2
            Button {
                width: parent.width
                text: qsTr("Select location")
                onClicked: {
                    console.warn("Location:", myMap.map.center)
                    activated(placename, myMap.map.center.latitude, myMap.map.center.longitude)
                    pageStack.pop()
                }
            }
            Button {
                text: qsTr("Cancel")
                onClicked: pageStack.pop()
            }
            TextField {
                id: latfield
                text: lat
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                onEditingFinished: { myMap.map.center.latitude = parseFloat(text) }
            }
            TextField {
                id: lonfield
                text: lon
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                onEditingFinished: { myMap.map.center.longitude = parseFloat(text) }
            }
            Label {
                text: qsTr("Name:")
            }
            TextField {
                id: thisplacename
            }
            Label {  // just to have a little space above the map
            }
        }

        MapView {
            id: myMap
            width: parent.width
            height: parent.height - select.height - 20
            map.plugin: mapPlugin
            map.center: QtPositioning.coordinate(root.lat,root.lon)
            map.onCenterChanged:{
                latfield.text = myMap.map.center.latitude.toFixed(4);
                lonfield.text = myMap.map.center.longitude.toFixed(4);
            }

            Rectangle {
                anchors.centerIn: parent
                height: 10
                width: 10
                radius: 5
                border.color: "green"
                color: "transparent"
            }
        }
    }
}

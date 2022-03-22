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

import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.15
import Qt.labs.settings 1.0

//import "../components"

Page {

    id: root
    property var watch: null
    property int batteryLevel: root.watch.batteryLevel
    property int columns: 1
    palette.window: "orange"

    header: ToolBar {
        id: header
        width: parent.width
        //Row{
        Row{
            id: statusRowLayout
            //spacing: units.gu(4)
            //anchors.top: parent.bottom

            Button { //back button
                icon.name: "draw-arrow-back"
                width: height
                onClicked: {
                    loadStack()
                    /*if (pageStack.depth > 1) {
                        loadStack()
                    } else {
                        loadStack()
                    }*/
                }
            }

            Image { //shows an icon for whether watch is connected or not
                id: syncIcon
                height: parent.height
                width: parent.height
                //color: Suru.foregroundColor
                source: curWatchConnected ? Qt.resolvedUrl("../img/ios-bluetooth-connected.svg") : Qt.resolvedUrl("../img/ios-bluetooth.svg")
            }

            Label { //text whether watch is connected
                height: parent.height
                id: syncLabel
                text: curWatchConnected ? "connected" : "disconnected"
            }

            Button {
                id: batteryIcon
                width: height
                icon.name: "battery-good" //maybe change this so the icon changes with battery
                onPressed: console.log(pageStack.currentItem, pageStack.depth)
            }

            Label {
                id: batteryLabel
                text: curWatchConnected ? getCurWatch().batteryLevel + ("%") : "unknown"
            }
        }
        Button { //button opens the quick settings menu
            id: settingsButton
            height: parent.height
            width: height
            anchors.right: parent.right
            Image {
                source: Qt.resolvedUrl("../img/md-settings.svg")
                anchors.fill: parent
            }
            onClicked: settingsPopup.open()
            Popup { //the quick settings menu itself
                id: settingsPopup
                y: parent.height
                x: parent.width - width
                //contentWidth: view.implicitWidth
                //contentHeight: view.implicitHeight
                padding: 0
                Column {
                    Button {
                        text: "Watch Selection"
                        onClicked: pageStack.push(Qt.resolvedUrl("WatchSelectionPage.qml"))
                    }
                    Button {

                        text: "UI settings"
                        onClicked: pageStack.push(Qt.resolvedUrl("UISettings.qml"))
                    }
                    Button {
                        text: "About"
                    }
                    Button {
                        text: "Service status"
                    }
                }
            }
        //}
        }
    }

    StackView {
        id: pageStack
        anchors.fill: parent
        clip: true
        Component.onCompleted: loadStack()
    }

    function loadStack() {
        pageStack.clear();
        console.log(watches.connectedToService,curWatch,watches)
        if (watches.connectedToService) {
            pageStack.push(Qt.resolvedUrl("MainMenuPage.qml"), {watch: getCurWatch(), columns: 2})
            //if pageStack

            if (!(curWatch  >= 0)) {
                pageStack.push(Qt.resolvedUrl("WatchSelectionPage.qml"), {watch: getCurWatch()})
            } else {
                pageStack.push(Qt.resolvedUrl("MainMenuPage.qml"), {watch: getCurWatch(), columns: 2})
            }
        } else {
            pageStack.clear();
            pageStack.push(Qt.resolvedUrl("LoadingPage.qml"));
        }
    }


    /*Binding {
        target: timeSyncSwitch
        property: "checked"
        value: settings.timeSync
    }*/
/*
    Connections {
        target: root.watch
        onTimeServiceReadyChanged: timeSync();
    }*/

    function timeSync() {
        if(root.watch.timeServiceReady && settings.timeSync) root.watch.setTime(Date())
    }

    //Connections {
        //target: root.watch
        //onNotificationServiceReadyChanged: setVib();
    //}

    function setVib() {
        if(root.watch.notificationServiceReady) root.watch.setVibration(settings.notifyVib)
    }

    //Component.onCompleted: root.watch.setScreenshotFileInfo("/home/phablet/.local/share/telescope.asteroidos/screenshot/'screenshot'ddMMyyyy_hhmmss'.jpg'");
}


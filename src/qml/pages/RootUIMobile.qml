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

/* This is the root of the mobile UI. Either this or the desktop UI is loaded by main.qml based on a user setting.
 * This UI is focused around providing larger buttons onscreen but involves more navigation.
 * Currently a lot of code is shared between the two UIs and this may lead to parity issues.
 */

import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.15
import Qt.labs.settings 1.0

Page {

    id: root
    property var watch: null
    palette.window: "orange"

    header: ToolBar {
        id: header
        width: parent.width
        Row{
            id: statusRowLayout

            Button { //back button
                icon.name: "draw-arrow-back"
                width: height
                onClicked: {
                    loadStack()
                }
            }

            Image { //shows an icon for whether watch is connected or not
                id: syncIcon
                height: parent.height
                width: parent.height
                source: curWatchConnected ? Qt.resolvedUrl("../img/ios-bluetooth-connected.svg") : Qt.resolvedUrl("../img/ios-bluetooth.svg")
            }

            Label { //text whether watch is connected //FIXME: misaligned text
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

            Label { //FIXME: misaligned text
                id: batteryLabel
                text: curWatchConnected ? watch.batteryLevel + ("%") : "unknown"
            }
        }

        Button { //button opens the quick settings menu
            id: settingsButton
            height: parent.height
            width: height
            anchors.right: parent.right
            onClicked: settingsPopup.open()

            Image {
                source: Qt.resolvedUrl("../img/md-settings.svg")
                anchors.fill: parent
            }

            Popup { //the quick settings menu itself
                id: settingsPopup
                y: parent.height
                x: parent.width - width
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
                        text: "Service status"
                    }

                    Button {
                        text: "About"
                    }
                }
            }
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
            pageStack.push(Qt.resolvedUrl("MainMenuPage.qml"), {watch: watch, columns: 2})
            if (!(curWatch  >= 0)) {
                pageStack.push(Qt.resolvedUrl("WatchSelectionPage.qml"), {watch: watch})
            } else {
                pageStack.push(Qt.resolvedUrl("MainMenuPage.qml"), {watch: watch, columns: 2})
            }
        } else {
            pageStack.clear();
            pageStack.push(Qt.resolvedUrl("LoadingPage.qml"));
        }
    }

    //Component.onCompleted: root.watch.setScreenshotFileInfo("/home/phablet/.local/share/telescope.asteroidos/screenshot/'screenshot'ddMMyyyy_hhmmss'.jpg'"); //TODO: change this to a path that's exists for the user and add a setting for this in UISettings.qml
}


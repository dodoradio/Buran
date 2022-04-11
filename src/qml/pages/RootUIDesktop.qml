/*
 * Copyright (C) 2022 - Arseniy Movshev <dodoradio@outlook.com>
 *               2018 - Florent Revest <revestflo@gmail.com>
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

/* This is the root of the desktop UI. Either this or the mobile UI is loaded by main.qml based on a user setting.
 * This UI is focused around providing more content on screen and having less navigation.
 * Currently a lot of code is shared between the two UIs and this may lead to parity issues.
 */

import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.15
import Qt.labs.settings 1.0

Page {

    id: root

    header: ToolBar {
        id: header
        width: parent.width
        height: 40 //TODO: change this from a static value
        Row{
            id: statusRowLayout
            height: parent.height

            Image { //shows an icon for whether watch is connected or not
                id: syncIcon
                height: parent.height
                width: parent.height
                source: curWatchConnected ? Qt.resolvedUrl("../img/ios-bluetooth-connected.svg") : Qt.resolvedUrl("../img/ios-bluetooth.svg")
            }

            Label { //text whether watch is connected
                id: syncLabel
                height: parent.height
                text: curWatchConnected ? "connected" : "disconnected"
                verticalAlignment: Text.AlignVCenter
            }

            Image {
                id: batteryIcon
                height: parent.height
                width: parent.height
                source: "../img/ios-battery-full.svg" //maybe change this so the icon changes with battery
            }

            Label {
                id: batteryLabel
                height: parent.height
                text: curWatchConnected ? watch.batteryLevel + ("%") : "unknown"
                verticalAlignment: Text.AlignVCenter
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
                        onClicked: pageStack.push(Qt.resolvedUrl("InfoPage.qml"))
                    }
                }
            }
        }
    }

    Settings {
        id: settings
        property alias menuPanelWidth: mainMenuPanel.width
    }

    SplitView {
        anchors.fill: parent
        height: parent.height

        MainMenuPage{
            id: mainMenuPanel
            contentHeight: layout.height
            clip: true
            anchors.rightMargin: 0
            anchors.bottomMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0
            implicitWidth: settings.menuPanelWidth
            width: parent.width/6
            palette.window: "orange"
        }

        StackView {
            id: pageStack
            clip: true
        }
    }

    function loadStack() {
        pageStack.clear();
        console.log(watches.connectedToService,curWatch,watches)
        if (watches.connectedToService) {
            if (!(curWatch  >= 0)) {
                pageStack.push(Qt.resolvedUrl("WatchSelectionPage.qml"))
            }
        } else {
            pageStack.clear();
            pageStack.push(Qt.resolvedUrl("LoadingPage.qml"));
        }
    }

    //Component.onCompleted: watch.setScreenshotFileInfo("/home/phablet/.local/share/telescope.asteroidos/screenshot/'screenshot'ddMMyyyy_hhmmss'.jpg'"); //TODO: change this to a path that's exists for the user and add a setting for this in UISettings.qml
}


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

/* This is the root of the mobile UI. Either this or the desktop UI is loaded by main.qml based on a user setting.
 * This UI is focused around providing larger buttons onscreen but involves more navigation.
 * Currently a lot of code is shared between the two UIs and this may lead to parity issues.
 */

import QtQuick 2.3
import QtCore
import QtQuick.Layouts 1.1
import Qt5Compat.GraphicalEffects
import QtQuick.Controls 2.15

import "../components/"

Page {

    id: root
    palette.window: settings.value("uiAccentColor","#f19a11")

    header: ToolBar {
        id: header
        width: parent.width
        height: 40 //TODO: change this from a static value
        Button { //back button
            icon.name: "draw-arrow-back"
            width: height
            height: parent.height
            flat: true
            onClicked: {
                loadStack()
            }
        }
        Row{
            id: statusRowLayout
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height

            Image { //shows an icon for whether watch is connected or not
                id: syncIcon
                height: parent.height
                width: parent.height
                source: curWatchConnected ? Qt.resolvedUrl("../img/ios-bluetooth-connected.svg") : Qt.resolvedUrl("../img/ios-bluetooth.svg")
            }

            Button { //text whether watch is connected
                id: syncLabel
                height: parent.height
                padding: height/4
                flat: true
                Label {
                    anchors.centerIn: parent
                    text: curWatchConnected && watch ? watch.name : "disconnected"
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: pageStack.push(Qt.resolvedUrl("WatchSelectionPage.qml"))
            }

            Image {
                id: batteryIcon
                height: parent.height
                width: parent.height
                source: "../img/ios-battery-full.svg" //maybe change this so the icon changes with battery
                Label {
                    anchors.centerIn: parent
                    id: batteryLabel
                    height: parent.height
                    text: curWatchConnected ? watch.batteryLevel + ("%") : null
                    verticalAlignment: Text.AlignVCenter
                    color: "white"
                    font.pixelSize: 9
                }
            }
        }
    }

    StackView {
        id: pageStack
        anchors.fill: parent
        clip: true
        Component.onCompleted: loadStack()
        Image {
            anchors.fill: parent
            source: Qt.resolvedUrl("../img/background-default.jpg")
            fillMode: Image.PreserveAspectCrop
            mipmap: true
        }
    }

    function loadStack() {
        pageStack.clear();
        console.log(watches.connectedToService,curWatch,watches)
        if (watches.connectedToService) {
            if (!(curWatch  >= 0)) {
                pageStack.push(Qt.resolvedUrl("WatchSelectionPage.qml"))
            } else {
                pageStack.push(Qt.resolvedUrl("MainMenuPage.qml"), {columns: 2})
            }
        } else {
            pageStack.clear();
            pageStack.push(Qt.resolvedUrl("LoadingPage.qml"));
        }
    }
    //Component.onCompleted: root.watch.setScreenshotFileInfo("/home/phablet/.local/share/telescope.asteroidos/screenshot/'screenshot'ddMMyyyy_hhmmss'.jpg'"); //TODO: change this to a path that's exists for the user and add a setting for this in UISettings.qml
}


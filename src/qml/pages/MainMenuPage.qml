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

/* This page is loaded in by either RootUIDesktop or RootUIMobile.
 * The two UI models handle this loading in different ways, the desktop UI presents it as a side panel, while
 * the mobile UI loads it as a part of the page stack.
 */

import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.15
import Qt.labs.settings 1.0
import "../components/"

Pane {
    id: root
    property int columns: 1

    Settings {
        id: settings
        property bool timeSync
    }

        Flickable {
            id: mainMenuPanel
            contentHeight: layout.height
            clip: true
            anchors.rightMargin: 0
            anchors.bottomMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0
            anchors.fill: parent

            Grid {
                id: layout
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                columns: root.columns
                //anchors.margins: Theme.paddingMedium

                IconButton { //time sync toggle
                    enabled: watch && watch.timeServiceReady
                    width: parent.width/layout.columns
                    property bool toggled: settings.timeSync
                    onPressed: {
                        toggled = !toggled
                        settings.timeSync = toggled
                        if(settings.timeSync == true) doTimeSync();

                    }
                    text: qsTr("Enable time synchronisation")
                    imageSource: Qt.resolvedUrl("../img/time-sync.svg")
                    state: toggled
                }

                IconButton { //notification settings button
                    enabled: watch && watch.timeServiceReady
                    width: parent.width/layout.columns
                    onClicked: {
                        pageStack.replace(Qt.resolvedUrl("NotificationSettingsPage.qml"))
                    }
                    imageSource: Qt.resolvedUrl("../img/ios-notifications-outline.svg")
                    text: qsTr("Notification settings")
                }

                IconButton { //watch finder button
                    enabled: watch && watch.screenshotServiceReady
                    width: parent.width/layout.columns
                    onClicked: {
                        watch.sendNotify(Qt.formatDateTime(new Date(), "zzz"), qsTr("Telescope"), "ios-watch-vibrating", qsTr("Watch-Finder"), localHostName + qsTr(" is looking for you!"), "strong")
                    }
                    imageSource: Qt.resolvedUrl("../img/ios-watch-vibrating.svg")
                    text: qsTr("Find my watch!")
                }

                IconButton { //screenshot button
                    enabled: watch && watch.timeServiceReady
                    width: parent.width/layout.columns
                    onClicked: {
                            //watch.requestScreenshot()
                            pageStack.replace("ScreenshotPage.qml")
                    }
                    imageSource: Qt.resolvedUrl("../img/md-images.svg")
                    text: qsTr("Take a screenshot")
                }

                IconButton { //weather settings button
                    enabled: watch && watch.timeServiceReady
                    width: parent.width/layout.columns
                    onClicked: {
                        pageStack.replace(Qt.resolvedUrl("WeatherSettingsPage.qml"))
                    }
                    imageSource: Qt.resolvedUrl("../img/ios-partly-sunny-outline.svg")
                    text: qsTr("Weather settings")
                }
            }
        }

    /*Binding {
        target: timeSyncSwitch
        property: "checked"
        value: settings.timeSync
    }*/

    Connections {
        target: watch
        function onTimeServiceReadyChanged() { doTimeSync(); }
    }

    function doTimeSync() {
        if(watch.timeServiceReady && settings.timeSync) watch.setTime(Date())
    }

    //Connections {
        //target: watch
        //onNotificationServiceReadyChanged: setVib();
    //}
    function onNotificationServiceReadyChanged() {
        setVib();
    }

    function setVib() {
        if(watch.notificationServiceReady) watch.setVibration(settings.notifyVib)
    }

    //Component.onCompleted: watch.setScreenshotFileInfo("/home/phablet/.local/share/telescope.asteroidos/screenshot/'screenshot'ddMMyyyy_hhmmss'.jpg'");
}


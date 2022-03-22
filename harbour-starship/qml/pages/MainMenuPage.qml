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

//import "../components"

Pane {
    //anchors.fill: parent
    id: root
    property var watch: null
    property int batteryLevel: root.watch.batteryLevel
    property int columns: 1



    //allowedOrientations: Orientation.All
    /*header: ToolBar {
        id: header
        RowLayout{
            id: statusRowLayout
            //spacing: units.gu(4)
            anchors.horizontalCenter: parent.horizontalCenter
            //anchors.top: parent.bottom

            RowLayout {
                //spacing: units.gu(0.5)
                //Layout.preferredHeight: units.gu(7)

                Button { //shows an icon for whether watch is connected or not
                    id: syncIcon
                    //width: units.gu(4)
                    //height: units.gu(4)
                    //color: Suru.foregroundColor
                    icon.name: /*watchConnected ? "network-bluetooth" :*/ /*"network-bluetooth-activated"
                }

                Label { //text whether watch is connected
                    id: syncLabel
                    text: curWatchConnected ? "connected" : "disconnected"
                }
            }

            RowLayout {
                //spacing: units.gu(0.5)

                Button {
                    id: batteryIcon
                    //width: units.gu(4)
                    //height: units.gu(3)
                    //color: Suru.foregroundColor
                    icon.name: "battery-good" //maybe change this so the icon changes with battery
                }

                Label {
                id: batteryLabel
                text: curWatchConnected ? batteryLevel + ("%") : "unknown"



                }
            }
        }
    }*/
        Flickable {
            id: mainMenuPanel
            contentHeight: layout.height
            clip: true
            anchors.rightMargin: 0
            anchors.bottomMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0
            anchors.fill: parent
            //palette.window: "orange"

            Grid {
                id: layout
                //spacing: 10
                //anchors.fill: parent
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                columns: root.columns
                //anchors.margins: Theme.paddingMedium

                MouseArea { //time sync toggle
                    enabled: root.watch.timeServiceReady
                    id: timeSyncButton
                    width: parent.width/layout.columns
                    height: width
                    property bool toggled: false  //change this to the value of timesync asap

                    onPressed: {
                        toggled = !toggled
                        //settings.timeSync = toggled
                        if(settings.timeSync == true) timeSync();

                    }

                    Item {
                        anchors.fill: parent
                        Rectangle {
                            id: timeSyncCircle
                            anchors.centerIn: parent
                            width: parent.width * 0.7
                            height: width
                            radius: width/2
                            color: timeSyncButton.toggled ? "#cccccc" : "#f4f4f4"
                        }
                    }
                    /*DropShadow {
                        anchors.fill: circleWrapper
                        horizontalOffset: 0
                        verticalOffset: 0
                        radius: 8.0
                        samples: 12
                        color: "#80000000"
                        source: circleWrapper
                        cached: true
                    }*/

                    Image {
                        id: timeSyncIcon
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: -parent.height * 0.03
                        width: parent.width * 0.31
                        height: width
                        //color: launcherItem.pressed | fakePressed ? "#444444" : "#666666"
                        source: Qt.resolvedUrl("../img/time-sync.svg")
                    }

                    Label {
                        anchors.top: timeSyncIcon.bottom
                        width: parent.width * 0.5
                        horizontalAlignment: Text.AlignHCenter
                        anchors.topMargin: parent.height * 0.04
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: timeSyncButton.toggled ? "#444444" : "#666666"
                        //font.pixelSize: ((appsListView.width > appsListView.height ? appsListView.height : appsListView.width) / Dims.l(100)) * Dims.l(5)
                        font.weight: Font.Medium
                        text: "enable time synchronisation"
                        wrapMode: Text.Wrap
                    }
                }

                MouseArea { //notification settings button
                    enabled: root.watch.timeServiceReady
                    id: notificationSettingsButton
                    width: parent.width/layout.columns
                    height: width

                    onClicked: {
                        pageStack.replace(Qt.resolvedUrl("NotificationSettingsPage.qml"))
                    }

                    Item {
                        anchors.fill: parent
                        Rectangle {
                            anchors.centerIn: parent
                            width: parent.width * 0.7
                            height: width
                            radius: width/2
                            color: notificationSettingsButton.pressed ? "#cccccc" : "#f4f4f4"
                        }
                    }
                    /*DropShadow {
                        anchors.fill: circleWrapper
                        horizontalOffset: 0
                        verticalOffset: 0
                        radius: 8.0
                        samples: 12
                        color: "#80000000"
                        source: circleWrapper
                        cached: true
                    }*/

                    Image {
                        id: notificationSettingsIcon
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: -parent.height * 0.03
                        width: parent.width * 0.31
                        height: width
                        //color: launcherItem.pressed | fakePressed ? "#444444" : "#666666"
                        source: Qt.resolvedUrl("../img/ios-notifications-outline.svg")
                    }

                    Label {
                        anchors.top: notificationSettingsIcon.bottom
                        width: parent.width * 0.5
                        horizontalAlignment: Text.AlignHCenter
                        anchors.topMargin: parent.height * 0.04
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: notificationSettingsButton.pressed ? "#444444" : "#666666"
                        //font.pixelSize: ((appsListView.width > appsListView.height ? appsListView.height : appsListView.width) / Dims.l(100)) * Dims.l(5)
                        font.weight: Font.Medium
                        text: "notification settings"
                    }
                }

                MouseArea { //watch finder button
                    enabled: root.watch.timeServiceReady
                    id: watchFinderButton
                    width: parent.width/layout.columns
                    height: width

                    onClicked: {
                        root.watch.sendNotify(Qt.formatDateTime(new Date(), "zzz"), qsTr("Telescope"), "ios-watch-vibrating", qsTr("Watch-Finder"), qsTr("The phone is looking for you!"))
                    }

                    Item {
                        anchors.fill: parent
                        Rectangle {
                            anchors.centerIn: parent
                            width: parent.width * 0.7
                            height: width
                            radius: width/2
                            color: watchFinderButton.pressed ? "#cccccc" : "#f4f4f4"
                        }
                    }
                    /*DropShadow {
                        anchors.fill: circleWrapper
                        horizontalOffset: 0
                        verticalOffset: 0
                        radius: 8.0
                        samples: 12
                        color: "#80000000"
                        source: circleWrapper
                        cached: true
                    }*/

                    Image {
                        id: watchFinderIcon
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: -parent.height * 0.03
                        width: parent.width * 0.31
                        height: width
                        //color: launcherItem.pressed | fakePressed ? "#444444" : "#666666"
                        source: Qt.resolvedUrl("../img/ios-watch-vibrating.svg")
                    }

                    Label {
                        anchors.top: watchFinderIcon.bottom
                        width: parent.width * 0.5
                        horizontalAlignment: Text.AlignHCenter
                        anchors.topMargin: parent.height * 0.04
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: watchFinderButton.pressed ? "#444444" : "#666666"
                        //font.pixelSize: ((appsListView.width > appsListView.height ? appsListView.height : appsListView.width) / Dims.l(100)) * Dims.l(5)
                        font.weight: Font.Medium
                        text: "find my watch"
                    }
                }

                MouseArea { //screenshot button
                    enabled: root.watch.screenshotServiceReady
                    id: screenshotButton
                    width: parent.width/layout.columns
                    height: width

                    onClicked: {
                            //root.watch.requestScreenshot()
                            pageStack.replace("ScreenshotPage.qml", {watch: watch})
                    }

                    Item {
                        anchors.fill: parent
                        Rectangle {
                            anchors.centerIn: parent
                            width: parent.width * 0.7
                            height: width
                            radius: width/2
                            color: screenshotButton.pressed ? "#cccccc" : "#f4f4f4"
                        }
                    }
                    /*DropShadow {
                        anchors.fill: circleWrapper
                        horizontalOffset: 0
                        verticalOffset: 0
                        radius: 8.0
                        samples: 12
                        color: "#80000000"
                        source: circleWrapper
                        cached: true
                    }*/

                    Image {
                        id: screenshotIcon
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: -parent.height * 0.03
                        width: parent.width * 0.31
                        height: width
                        //color: launcherItem.pressed | fakePressed ? "#444444" : "#666666"
                        source: Qt.resolvedUrl("../img/md-images.svg")
                    }

                    Label {
                        anchors.top: screenshotIcon.bottom
                        width: parent.width * 0.5
                        horizontalAlignment: Text.AlignHCenter
                        anchors.topMargin: parent.height * 0.04
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: watchFinderButton.pressed ? "#444444" : "#666666"
                        //font.pixelSize: ((appsListView.width > appsListView.height ? appsListView.height : appsListView.width) / Dims.l(100)) * Dims.l(5)
                        font.weight: Font.Medium
                        text: "take a screenshot"
                    }
                }

                MouseArea { //weather settings button
                    enabled: root.watch.timeServiceReady
                    id: weatherSettingsButton
                    width: parent.width/layout.columns
                    height: width

                    onClicked: {
                        pageStack.replace(Qt.resolvedUrl("WeatherSettingsPage.qml"))

                    }

                    Item {
                        anchors.fill: parent
                        Rectangle {
                            anchors.centerIn: parent
                            width: parent.width * 0.7
                            height: width
                            radius: width/2
                            color: weatherSettingsButton.pressed ? "#cccccc" : "#f4f4f4"
                        }
                    }
                    /*DropShadow {
                        anchors.fill: circleWrapper
                        horizontalOffset: 0
                        verticalOffset: 0
                        radius: 8.0
                        samples: 12
                        color: "#80000000"
                        source: circleWrapper
                        cached: true
                    }*/

                    Image {
                        id: weatherSettingsIcon
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: -parent.height * 0.03
                        width: parent.width * 0.31
                        height: width
                        //color: launcherItem.pressed | fakePressed ? "#444444" : "#666666"
                        source: Qt.resolvedUrl("../img/ios-partly-sunny-outline.svg")
                    }

                    Label {
                        anchors.top: weatherSettingsIcon.bottom
                        width: parent.width * 0.5
                        horizontalAlignment: Text.AlignHCenter
                        anchors.topMargin: parent.height * 0.04
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: weatherSettingsButton.pressed ? "#444444" : "#666666"
                        //font.pixelSize: ((appsListView.width > appsListView.height ? appsListView.height : appsListView.width) / Dims.l(100)) * Dims.l(5)
                        font.weight: Font.Medium
                        text: "weather settings"
                    }
                }
            }
        }

    /*Binding {
        target: timeSyncSwitch
        property: "checked"
        value: settings.timeSync
    }*/

    Connections {
        target: root.watch
        onTimeServiceReadyChanged: timeSync();
    }

    function timeSync() {
        if(root.watch.timeServiceReady && settings.timeSync) root.watch.setTime(Date())
    }

    Connections {
        target: root.watch
        onNotificationServiceReadyChanged: setVib();
    }

    function setVib() {
        if(root.watch.notificationServiceReady) root.watch.setVibration(settings.notifyVib)
    }

    Component.onCompleted: root.watch.setScreenshotFileInfo("/home/phablet/.local/share/telescope.asteroidos/screenshot/'screenshot'ddMMyyyy_hhmmss'.jpg'");
}


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
import org.asteroid.syncservice 1.0
import QtQuick.Controls 2.15
import "pages"

Page {
    property alias curWatch: watches.currentWatch
    property alias curWatchConnected: watches.currentWatchConnected
    property string version: Qt.application.version;

    id: starship
    width: 320
    height: 480
    focus: true

    header: ToolBar {
        id: header
        Row{
            id: statusRowLayout
            //spacing: units.gu(4)
            anchors.fill: parent
            //anchors.top: parent.bottom
            Button {
                icon.name: "draw-arrow-back"
                onClicked: {
                    loadStack()
                    /*if (pageStack.depth > 1) {
                        loadStack()
                    } else {
                        loadStack()
                    }*/
                }
                width: height
            }

            Row {
                height: parent.height
                width: parent.width/2
                //spacing: units.gu(0.5)
                //Layout.preferredHeight: units.gu(7)

                Image { //shows an icon for whether watch is connected or not
                    id: syncIcon
                    height: parent.height
                    width: height
                    //color: Suru.foregroundColor
                    source: watchConnected ? Qt.resolvedUrl("./img/ios-bluetooth-connected.svg") : Qt.resolvedUrl("./img/ios-bluetooth.svg")
                }

                Label { //text whether watch is connected
                    height: parent.height
                    id: syncLabel
                    text: curWatchConnected ? "connected" : "disconnected"
                }
            }

            Row {
                //spacing: units.gu(0.5)

                Button {
                    id: batteryIcon
                    //width: units.gu(4)
                    //height: units.gu(3)
                    //color: Suru.foregroundColor
                    icon.name: "battery-good" //maybe change this so the icon changes with battery
                    onPressed: console.log(pageStack.currentItem, pageStack.depth)
                }

                Label {
                id: batteryLabel
                text: curWatchConnected ? batteryLevel + ("%") : "unknown"



                }
            }
        }
    }

    MainMenuPage {
       id: mainMenu
       height: parent.height
       width: true ? (parent.height/parent.width > 1 ? parent.width : parent.width/5) : 0
       columns: parent.height/parent.width > 1 ? 2 : 1
       palette.window: "orange"
       Behavior on width { NumberAnimation { duration: 100 } }
   }

    StackView {
        id: pageStack
        anchors.top: parent.top
        anchors.left: parent.height/parent.width > 1 ? parent.left : mainMenu.right
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        //palette.window: "orange"
        clip: true
        initialItem: Item{}
    }
//    cover: Qt.resolvedUrl("cover/CoverPage.qml")


    ServiceController {
        id: settings
    }

    Watches {
        id: watches
        onCountChanged: loadStack()
        onConnectedToServiceChanged: loadStack()
        onCurrentWatchChanged: {
            console.log("onCurrentWatchChanged" + curWatch)
            loadStack()
        }
    }

    function startBT() {
        lipstick.typedCall("notifyLaunching",[{"type":"s","value":"jolla-settings.desktop"}],
                           function(r){jolla.call("showPage",["system_settings/connectivity/bluetooth"])},
                           function(e){console.log("Error",e)})
    }

    function initService() {
        if (!watches.connectedToService && !serviceController.serviceRunning) {
            serviceController.startService();
        }

/*        if (watches.version !== version) {
            console.log("Service file version (", version, ") is not equal running service version (", watches.version, "). Restarting service.");
            serviceController.restartService();
        }*/
    }

    function restartService() {
        serviceController.restartService()
    }

    function loadStack() {
        pageStack.clear();
        console.log(watches.connectedToService,curWatch,watches)
        if (watches.connectedToService) {
            //if pageStack

            if (!(curWatch  >= 0)) {
                pageStack.push(Qt.resolvedUrl("pages/WatchSelectionPage.qml"), {watch: getCurWatch()})
            }
        } else {
            pageStack.clear();
            pageStack.push(Qt.resolvedUrl("pages/LoadingPage.qml"));
        }
    }

    function getCurWatch() {
        if(curWatch >= 0) return watches.get(curWatch);
        return null;
    }

}

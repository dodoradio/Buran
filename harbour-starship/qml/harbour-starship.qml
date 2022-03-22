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
import Qt.labs.settings 1.0
import "pages"

Page {
    property alias curWatch: watches.currentWatch
    property alias curWatchConnected: watches.currentWatchConnected
    property string version: Qt.application.version;

    id: starship
    width: 320
    height: 480
    focus: true

    ServiceController {
        id: serviceController
        Component.onCompleted: initService()
        Component.onDestruction: serviceController.stopService()
    }
    Settings {
        id: settings
        fileName: "/home/dodoradio/Projects/buran/settings.txt"
        property alias windowWidth: starship.width
        property alias windowHeight: starship.height
        //Component.onCompleted: uiLoader.source = settings.value("uiStyle",1) ? "pages/MainMenuPageDesktop.qml" : "pages/MainMenuPageMobile.qml"
    }

    Loader {
        id: uiLoader
        anchors.fill: parent
        source: false ? "pages/RootUIDesktop.qml" : "pages/RootUIMobile.qml"
        onLoaded: {
            item.anchors.fill = item.parent
            item.watch = getCurWatch()
            //item.palette.window = "orange"
        }
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
        serviceController.startService();
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

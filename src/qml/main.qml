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
import QtQuick.Window 2.2
import "pages"

ApplicationWindow {
    property alias curWatch: watches.currentWatch
    property alias curWatchConnected: watches.currentWatchConnected
    property string version: Qt.application.version;

    id: buranWindow
    width: 320
    height: 480
    visibility: "AutomaticVisibility"
    visible: true

    ServiceController {
        id: serviceController
        Component.onCompleted: initService()
        Component.onDestruction: serviceController.stopService()
    }

    Settings {
        id: settings
        property alias windowWidth: buranWindow.width
        property alias windowHeight: buranWindow.height
        property alias windowX: buranWindow.x
        property alias windowY: buranWindow.y
        Component.onCompleted: uiLoader.setSource(settings.value("uiStyle", 1) < 1 ? "pages/RootUIDesktop.qml" : "pages/RootUIMobile.qml")
    }

    Loader {
        id: uiLoader
        anchors.fill: parent
        onLoaded: {
            item.anchors.fill = item.parent
            item.watch = getCurWatch()
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

    function loadStack() {
        uiLoader.item.loadStack()
    }

    function initService() {
        if (!watches.connectedToService && !serviceController.serviceRunning) {
            console.log("asteroidsyncservice is not running. Attempting to start the service.")
            serviceController.startService();
        }

        if (watches.version !== version) {
            console.log("Service file version (", version, ") is not equal running service version (", watches.version, "). Restarting service.");
            serviceController.restartService();
        }
    }

    function restartService() {
        serviceController.restartService()
    }

    function getCurWatch() {
        if(curWatch >= 0) return watches.get(curWatch);
        return null;
    }

}

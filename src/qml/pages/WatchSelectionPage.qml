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
import QtQuick.Controls 2.15

Page {
    ListView {
        anchors.fill: parent
        model: watches

        /*header: Rectangle {
            //title: qsTr("Starship")
            //description: qsTr("Manage Watches")
        }*/

        delegate: Button {
            enabled: watches.count !== 0
            width: parent.width

            Row {
                width: parent.width

                Image {
                    source: Qt.resolvedUrl("../img/md-watch.svg")
                    height: coolumn.height
                    width: height
                }

                Column {
                    id: coolumn
                    Label {
                        text: name
                    }

                    Label {
                        text: address
                    }
                }
            }

            onClicked: watches.selectWatch(index)
        }

        Rectangle {
            visible: (watches.count === 0)
            anchors.fill: parent

            Label {
                id: noWatchLabel
                text: qsTr(watches.count + "No smartwatches configured yet. Please connect your smartwatch using System Settings.")
                //font.pixelSize: Theme.fontSizeLarge
                //width: parent.width-(Theme.paddingSmall*2)
                anchors.centerIn: parent
                //anchors.bottomMargin: Theme.paddingLarge
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }

            Button {
                text: qsTr("Open Bluetooth Settings")
                anchors.horizontalCenter: parent.horizontalCenter
                //anchors.topMargin: Theme.paddingLarge
                anchors.top: noWatchLabel.bottom
                onClicked: starship.startBT()
            }
        }
    }
}

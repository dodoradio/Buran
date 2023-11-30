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

import QtQuick 2.2
import QtQuick.Controls 2.15

Image {
    id: root
    fillMode: Image.PreserveAspectCrop
    Flickable {
        id: scrollPanel
        anchors.fill: parent
        contentHeight: contentPanel.height + parent.height/2 + 18
        Rectangle {
            id: contentPanel
            color: "#FFFFFF"
            opacity: 0.8
            radius: 8
            anchors.margins: 18
            anchors.left: parent.left
            anchors.right: parent.right
            height: column.implicitHeight + 18
            //height: column.implicitHeight - root.height/2
            y: root.height/2
            Column {
                id: column
                anchors.top: parent.top
                width: parent.width
                Item {
                    height: logo.height/2 + 18
                    width: parent.width
                }
                Label {
                    width: parent.width
                    text: qsTr("Version %1").arg(Qt.application.version)
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                }
                Item {
                    width: parent.width
                    height: 18
                }
                Label {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    leftPadding: parent.width/10
                    rightPadding: parent.width/10
                    text: "This program is free software: you can redistribute it and/or modify "
                        + "it under the terms of the GNU General Public License as published "
                        + "by the Free Software Foundation, version 3 of the License.<br>"
                        + "This program is distributed in the hope that it will be useful, "
                        + "but WITHOUT ANY WARRANTY; without even the implied warranty of "
                        + "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the "
                        + "GNU General Public License for more details.<br>"
                        + "You should have received a copy of the GNU General Public License "
                        + "along with this program.  If not, see <a href=\"http://www.gnu.org/"
                        + "licenses/\">http://www.gnu.org/licenses</a>."
                    wrapMode: Text.WordWrap
                }
                Item {
                    width: parent.width
                    height: 18
                }
                Label {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    leftPadding: parent.width/10
                    rightPadding: parent.width/10
                    text: "Thanks to NASA for the wonderful default background."
                    wrapMode: Text.WordWrap
                }
            }
        }
        Image {
            id: logo
            source: "../img/buran.svg"
            width: height
            anchors.verticalCenter: contentPanel.top
            anchors.horizontalCenter: contentPanel.horizontalCenter
        }
    }
}


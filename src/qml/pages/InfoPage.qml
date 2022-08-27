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
    //anchors.fill: parent
    //height: 200
    fillMode: Image.PreserveAspectCrop
    //source: "../img/harbour-starship.svg" //TODO: replace this with a proper image
    Flickable {
        id: scrollPanel
        anchors.fill: parent
        contentHeight: column.height + parent.height/2
        //anchors.margins: Theme.paddingLarge

        //Column {
            //anchors.fill: parent

            Rectangle {
                id: contentPanel
                width: parent.width
                //height: childrenRect.height
                //height: column.implicitHeight - root.height/2
                y: root.height/2
                height: parent.height
                Image {
                    id: logo
                    source: "../img/harbour-starship.svg"
                    //height: Theme.iconSizeLarge
                    width: height
                    anchors.verticalCenter: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Column {
                    id: column
                    anchors.top: logo.bottom
                    width: parent.width
                    Label {
                        width: parent.width
                        text: qsTr("Version %1").arg(Qt.application.version)
                        font.bold: true
                        //color: Theme.highlightColor
                        //font.pixelSize: Theme.fontSizeLarge
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Label {
                        //anchors.top: column.bottom
                        //anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width*0.8
                        leftPadding: parent.width/10
                        //font.pixelSize: Theme.fontSizeSmall
                        //color: Theme.highlightColor
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
                        //anchors.top: column.bottom
                        //anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width*0.8
                        leftPadding: parent.width/10
                        //font.pixelSize: Theme.fontSizeSmall
                        //color: Theme.highlightColor
                        text: "Thanks to NASA for the wonderful default background."
                        wrapMode: Text.WordWrap
                    }
                }
            //}
        }
    }
}


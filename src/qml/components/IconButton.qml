/*
 * Copyright (C) 2022 Arseniy Movshev <dodoradio@outlook.com>
 *               2020 Mara Sophie Grosch <littlefox@lf-net.org>
 *               2015 Florent Revest <revestflo@gmail.com>
 *               2014 Aleksi Suomalainen <suomalainen.aleksi@gmail.com>
 *               2012 Timur Kristóf <venemo@fedoraproject.org>
 *               2011 Tom Swindell <t.swindell@rubyx.co.uk>
 * All rights reserved.
 *
 * You may use this file under the terms of BSD license as follows:
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the author nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import QtQuick 2.9
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.12

MouseArea {
        id: buttonRoot
        width: appsListView.width / 2
        height: width
        enabled: true
        property string text
        property string imageSource
        property bool state: pressed

        Rectangle {
            id: circle
            anchors.centerIn: parent
            width: parent.width * 0.7
            height: width
            radius: width/2
            color: buttonRoot.state ? "#cccccc" : "#f4f4f4"
        }
        //DropShadow {
            //anchors.centerIn: parent
            //width: parent.width * 0.7
            //height: width
            //horizontalOffset: 0
            //verticalOffset: 0
            //radius: 8.0
            //samples: 12
            //color: "#80000000"
            //source: circle
            //cached: true
            //visible: !buttonRoot.state
        //}

        Image {
            id: icon
            anchors.centerIn: parent
            width: parent.width * 0.4
            height: width
            //color: buttonRoot.pressed | fakePressed ? "#444444" : "#666666"
            //name: model.object.iconId === "" ? "ios-help" : model.object.iconId
            source: parent.imageSource
        }

        Label {
            id: iconText
            anchors.top: circle.bottom
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            //anchors.topMargin: parent.height * 0.42
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#000000"
            font.pixelSize: 15//((appsListView.width > appsListView.height ? appsListView.height : appsListView.width) / Dims.l(100)) * Dims.l(5)
            //font.styleName: "SemiCondensed Bold"
            //font.letterSpacing: parent.width * 0.002
            text: parent.text
            layer.enabled: true
//             layer.effect: DropShadow {
//                 transparentBorder: true
//                 horizontalOffset: 0
//                 verticalOffset: 0
//                 radius: 3.0
//                 samples: 3
//                 color: "#80000000"
//             }
        }
    }


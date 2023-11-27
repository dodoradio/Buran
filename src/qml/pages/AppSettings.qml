import QtQuick 2.4
import QtCore
import QtQuick.Controls 2.15
import QtQuick.Dialogs
Item {
    Rectangle {
        color: "#FFFFFF"
        opacity: 0.8
        radius: 8
        anchors.fill: parent
        anchors.margins: 18
        Flickable {
            anchors.fill: parent
            anchors.margins: 8
            Settings {
                id: settings
                property alias uiStyle: uiSwitch.position
            }
            Column {
                Row {
                    Switch { //The switch between Mobile and desktop UI
                        id: uiSwitch
                    }
                    Label {
                        text: "Enable the mobile UI"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                //TODO: add an adjustment to the number of columns in the menubar. The two values should be independent for mobile and desktop.
                Button {
                    onPressed: {
                        colorDialog.trigger = "uiAccentColor"
                        colorDialog.color = settings.value("uiAccentColor")
                        colorDialog.visible = true
                    }
                    text: qsTr("pick UI accent colour")
                }
                ColorDialog {
                    id: colorDialog
                    title: "Please choose a color"
                    property var trigger
                    onAccepted: {
                        settings.setValue(trigger,color);
                        visible = false
                    }
                    onRejected: {
                        visible = false
                    }
                    //Component.onCompleted: visible = false
                }

                Button {
                    text: "reload UI"
                    onClicked: reloadUI()
                }
                Button {
                    text: "About"
                    onClicked: pageStack.push(Qt.resolvedUrl("../pages/InfoPage.qml"))
                }
            }
        }
    }
}

import QtQuick 2.4
import QtQuick.Controls 2.15
import Qt.labs.settings 1.0

Column {
    width: parent.width
    Button {
        text: "wow we got the thing loaded!"
        onClicked: watches.selectWatch(-1)
    }
    Row {
        width: parent.width
        Column {
            //width: parent.width
            Label {
                text: "Mobile UI"
            }
            Label {
                text: "removes the persistent main menu from the edge of the screen"
            }
        }
        Switch {
            id: uiSwitch
            Settings {
                fileName: "/home/dodoradio/Projects/buran/settings.txt"
                property alias uiStyle: uiSwitch.position
            }
        }
    }
}

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
            } //TODO: some kind of word wrap so this fits on narrow screens
            //TODO: add text 'restart required for changes to take effect
        }
        Switch {
            id: uiSwitch
            Settings {
                property alias uiStyle: uiSwitch.position
            }
        }
        //TODO: add an adjustment to the number of columns in the menubar. The two values should be independent for mobile and desktop.
    }

}

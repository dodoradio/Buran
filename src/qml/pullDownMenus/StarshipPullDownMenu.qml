import QtQuick 2.2
import QtQuick.Controls 2.15


Menu {
    MenuItem {
        text: qsTr("About")
        onClicked: pageStack.push(Qt.resolvedUrl("../pages/InfoPage.qml"))
    }
    MenuItem {
        text: qsTr("Bluetooth Settings")
        onClicked: starship.startBT()
    }
    MenuItem {
        text: qsTr("Restart service")
        onClicked: starship.restartService()
    }
}

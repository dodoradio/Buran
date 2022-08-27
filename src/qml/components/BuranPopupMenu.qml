import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt.labs.settings 1.0
import "../pages/"
Button { //button opens the quick settings menu
    id: settingsButton
    height: parent.height
    width: height
    anchors.right: parent.right
    Image {
        source: Qt.resolvedUrl("../img/md-settings.svg")
        anchors.fill: parent
    }
    onClicked: settingsPopup.open()
    Popup { //the quick settings menu itself
        id: settingsPopup
        y: parent.height + 8
        x: parent.width - (width + 8)
        padding: 0
        background: Rectangle {
            color: "light grey"
            radius: 4
        }
        Column {
            Button {
                text: "Watch Selection"
                onClicked: pageStack.push(Qt.resolvedUrl("../pages/WatchSelectionPage.qml"))
                background: null
                //width: parent.width
            }
            Button {

                text: "App Settings"
                onClicked: pageStack.push(Qt.resolvedUrl("../pages/AppSettings.qml"))
                background: null
                //width: parent.width
            }
            Button {
                text: "Service status"
                background: null
                //width: parent.width
            }
            Button {
                text: "About"
                onClicked: pageStack.push(Qt.resolvedUrl("../pages/InfoPage.qml"))
                background: null
                //width: parent.width
            }
        }
    }
}

import QtQuick 2.4
import QtQuick.Controls 2.15

Page { //TODO: add a label to indicate what the app is working on (cannot connect to service, attempting to pair)
    id: root

    property bool wantConnect: true

    header: Rectangle {
        id: header
    } 

    BusyIndicator {
        id: activity

        running: true //!watches.connectedToService && root.actionContext.active && wantConnect
        anchors.centerIn: parent 
    }     
}

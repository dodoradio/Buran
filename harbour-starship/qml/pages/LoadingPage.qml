import QtQuick 2.4
import QtQuick.Controls 2.15

Page {
    id: root

    property bool wantConnect: true

    header: Rectangle {
        id: header
        
/*        StyleHints {
            foregroundColor: "#FFF"
            backgroundColor: "#E5822B"
            dividerColor: "#85D8CE"
        }*/
    } 

    BusyIndicator {
        id: activity

        running: true //!watches.connectedToService && root.actionContext.active && wantConnect
        anchors.centerIn: parent 
    }     
}

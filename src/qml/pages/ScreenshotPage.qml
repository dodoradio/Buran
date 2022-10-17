import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.15
import QtQuick.Dialogs

Pane {
    id: scrShot
    
    MessageDialog {
        id: notification
        visible: false
        buttons: MessageDialog.Ok
    }

    Label {
        id: progessLabel
        anchors.centerIn: parent 
        visible: watch.screenshotProgress != 99
        color: "black"
        horizontalAlignment: Text.AlignHCenter
        text: watch.screenshotProgress + "%"
    }

    Image {
        id: screenshotImage
        anchors.centerIn: parent 
        visible: !progessLabel.visible
        width: parent.width  
        height: width
    }
    
    Connections {
        target: watch
        function onScreenshotReceived(screenshotPath) {
            screenshotImage.source = "file://" + screenshotPath
            notification.text = "File saved under " + screenshotPath
            notification.visible = true
        }
    }

}

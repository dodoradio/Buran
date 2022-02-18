import QtQuick 2.4
import QtQuick.Controls 2.15

Pane {
    id: notificationServiceItem
    anchors.fill: parent

    ListModel {
        id: notificationModel
        Component.onCompleted: initialize()

        function initialize() {
            notificationModel.append({"text": qsTr("None"), "value": "None"})
            notificationModel.append({"text": qsTr("Normal"), "value": "Normal"})
            notificationModel.append({"text": qsTr("Strong"), "value": "Strong"})
        }
    }

    ListView {
        id: notificationSetting
        objectName: "notificationSetting"

        //listViewHeight: notificationModel.count*units.gu(6.1)
        model: notificationModel
        //title.text: qsTr("Vibration on notification")
        //subText.text: qsTr(settings.notifyVib)

        delegate: Button {
            //title.text: model.text
            icon.name: "select"
            //icon.visible: settings.notifyVib === model.value

            onClicked: {
                settings.notifyVib = model.value
                setVib()
                notificationSetting.toggleExpansion()
            }
        }
    }
}

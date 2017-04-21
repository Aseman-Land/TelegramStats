import QtQuick 2.0
import AsemanTools 1.1
import TelegramQml 2.0
import QtQuick.Controls 2.0

Page {
    signal codeSend(string code)

    Column {
        width: parent.width - 40*Devices.density
        anchors.centerIn: parent

        TextField {
            id: codeField
            width: parent.width
            placeholderText: qsTr("Code")
        }

        Button {
            width: parent.width
            text: qsTr("Send Code")
            highlighted: true
            onClicked: codeSend(codeField.text)
        }
    }
}

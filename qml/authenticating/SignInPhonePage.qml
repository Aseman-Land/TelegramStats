import QtQuick 2.0
import AsemanTools 1.1
import TelegramQml 2.0
import QtQuick.Controls 2.0

Page {
    property Engine engine

    CountriesModel {
        id: cModel
        Component.onCompleted: cCombo.currentIndex = indexOf(systemCountry)
    }

    Column {
        width: parent.width - 40*Devices.density
        anchors.centerIn: parent

        ComboBox {
            id: cCombo
            width: parent.width
            textRole: "name"
            model: cModel
        }

        TextField {
            id: phoneField
            width: parent.width
            placeholderText: qsTr("Phone number")
        }

        Button {
            width: parent.width
            text: qsTr("Sign-in")
            highlighted: true
            onClicked: {
                var code = "+" + cModel.get(cCombo.currentIndex, CountriesModel.CallingCodeRole)
                engine.phoneNumber = code + phoneField.text
            }
        }
    }


}

import QtQuick 2.0
import AsemanTools 1.1
import TelegramQml 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3 as QtLayouts

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

        QtLayouts.RowLayout {
            width: parent.width

            TextField {
                id: countryCodeField
                text: "+" + cModel.get(cCombo.currentIndex, CountriesModel.CallingCodeRole)
                readOnly: true
                QtLayouts.Layout.preferredWidth: 64*Devices.density
            }

            TextField {
                id: phoneField
                width: parent.width
                placeholderText: qsTr("Phone number")
                QtLayouts.Layout.fillWidth: true
            }
        }

        Button {
            width: parent.width
            text: qsTr("Sign-in")
            highlighted: true
            onClicked: {
                var code = countryCodeField.text
                engine.phoneNumber = code + phoneField.text
            }
        }
    }


}

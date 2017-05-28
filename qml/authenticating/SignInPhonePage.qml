import QtQuick 2.0
import AsemanTools 1.1
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3 as QtLayouts

Item {
    property variant engine

    CountriesModel {
        id: cModel
        Component.onCompleted: cCombo.currentIndex = indexOf(systemCountry)
    }

    Column {
        width: parent.width - 40*Devices.density
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height/2 - height/2 - 64*Devices.density

        Image {
            width: 128*Devices.density
            height: width
            sourceSize: Qt.size(width*2, height*2)
            fillMode: Image.PreserveAspectCrop
            source: "../files/icon.png"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Item { width: 1; height: 10*Devices.density }

        Label {
            text: qsTr("Telegram Stats")
            font.pixelSize: 15*Devices.fontDensity
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Item { width: 1; height: 20*Devices.density }

        Label {
            text: qsTr("Please enter your phone number below")
            font.pixelSize: 9*Devices.fontDensity
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }

        Item { width: 1; height: 4*Devices.density }

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
                inputMethodHints: Qt.ImhDigitsOnly
                validator: RegExpValidator { regExp: /\d+/g }
                placeholderText: qsTr("Phone number")
                QtLayouts.Layout.fillWidth: true
                onAccepted: signIn()
            }
        }

        Button {
            width: parent.width
            text: qsTr("Sign-in")
            highlighted: true
            onClicked: signIn()
        }
    }

    Label {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20*Devices.density
        text: qsTr("Powered by <a href=\"http://aseman.co\">Aseman Team</a>")
        font.pixelSize: 8*Devices.fontDensity
        onLinkActivated: Qt.openUrlExternally(link)
    }

    function signIn(){
        var code = countryCodeField.text
        var phone = fixPhone(phoneField.text)
        if(phone.length < 5) {
            showTooltip( qsTr("Phone number length is too low") )
            return
        }

        engine.phoneNumber = code + phone
    }

    function fixPhone(phone) {
        var res = ""
        for(var i=0; i<phone.length; i++) {
            if( phone[i] == '0')
                continue
            else {
                res = phone.slice(i, phone.length)
                break
            }
        }
        return res
    }
}

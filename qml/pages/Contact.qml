import AsemanTools 1.1
import AsemanTools.MaterialIcons 1.0
import QtQuick 2.7
import QtQuick.Controls 2.0 as QtControls
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import "."
import "../globals"

QtControls.Page {
    anchors.fill: parent

    AndroidListEffect {
        width: parent.width
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        flickable: Devices.isDesktop? flick : null

        AsemanFlickable {
            id: flick
            anchors.fill: parent
            flickableDirection: Flickable.VerticalFlick
            contentHeight: column.height + 20*Devices.density
            contentWidth: width
            clip: true

            ColumnLayout {
                id: column
                width: flick.width - 20*Devices.density
                anchors.centerIn: parent

                QtControls.TextField {
                    id: fName
                    placeholderText: qsTr("Full name")
                    horizontalAlignment: View.defaultLayout? Text.AlignLeft : Text.AlignRight
                    font.pixelSize: 9*Devices.fontDensity
                    font.family: AsemanApp.globalFont.family
                    Layout.fillWidth: true
                }

                QtControls.TextField {
                    id: email
                    placeholderText: qsTr("Email")
                    horizontalAlignment: View.defaultLayout? Text.AlignLeft : Text.AlignRight
                    font.pixelSize: 9*Devices.fontDensity
                    font.family: AsemanApp.globalFont.family
                    Layout.fillWidth: true
                }

                QtControls.TextArea {
                    id: body
                    placeholderText: qsTr("Your Message")
                    horizontalAlignment: View.defaultLayout? Text.AlignLeft : Text.AlignRight
                    font.pixelSize: 9*Devices.fontDensity
                    font.family: AsemanApp.globalFont.family
                    Layout.fillWidth: true
                    Layout.preferredHeight: 128*Devices.density

                    TextCursorArea { textItem: body }
                }

                QtControls.Button {
                    Layout.fillWidth: true
                    text: qsTr("Send")
                    font.pixelSize: 9*Devices.fontDensity
                    font.family: AsemanApp.globalFont.family
                    highlighted: true
                    enabled: fName.length && email.length && body.length
                    onClicked: {
                        indicator.running = true
                        AsemanServices.turquoiseTiles.contact(fName.text, email.text, body.text, function(res, error){
                            indicator.running = false
                            if(res) {
                                BackHandler.back()
                                showTooltip( qsTr("Your message sent") )
                            } else {
                                showTooltip( qsTr("Can't send your message") )
                            }
                        })
                    }
                    Material.accent: TgChartsGlobals.masterColor
                }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#88ffffff"
        visible: indicator.running

        NullMouseArea {
            anchors.fill: parent
        }

        QtControls.BusyIndicator {
            id: indicator
            anchors.centerIn: parent
            running: false
            height: 48*Devices.density
            width: height
            transformOrigin: Item.Center
        }
    }

    Header {
        id: header
        width: parent.width
        color: TgChartsGlobals.masterColor
        titleFont.pixelSize: 10*Devices.fontDensity
        text: qsTr("Contact")
    }
}

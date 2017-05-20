import QtQuick 2.0
import AsemanTools 1.1
import AsemanTools.Awesome 1.0
import TelegramQml 2.0 as Telegram
import QtQuick.Controls 2.0 as QtControls
import "../authenticating" as Auth
import "../toolkit" as Toolkit
import "../pages" as Pages
import "../globals"

Rectangle {
    id: sideMenu

    property alias engine: profilePic.engine

    Rectangle {
        id: headRect
        width: parent.width
        height: 2*width/3
        color: TgChartsGlobals.masterColor

        Column {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 20*Devices.density
            spacing: 2*Devices.density

            Toolkit.ProfileImage {
                id: profilePic
                width: 64*Devices.density
                height: width
                source: engine.our.user
            }

            Item { width: 2; height: 6*Devices.density }

            QtControls.Label {
                color: "#ffffff"
                font.pixelSize: 10*Devices.fontDensity
                text: engine.our.user.firstName + " " + engine.our.user.lastName
            }

            QtControls.Label {
                color: "#ffffff"
                font.pixelSize: 9*Devices.fontDensity
                font.bold: true
                text: engine.phoneNumber
            }
        }
    }

    AsemanListView {
        id: listv
        width: parent.width
        anchors.top: headRect.bottom
        anchors.bottom: parent.bottom
        clip: true
        model: ListModel {}
        delegate: QtControls.ItemDelegate {
            width: listv.width
            height: 48*Devices.density
            hoverEnabled: false

            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 18*Devices.density
                layoutDirection: View.layoutDirection
                spacing: 32*Devices.density

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    font.family: Awesome.family
                    font.pixelSize: 13*Devices.fontDensity
                    text: model.icon
                    color: TgChartsGlobals.foregroundColor
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    color: TgChartsGlobals.foregroundColor
                    font.pixelSize: 9*Devices.fontDensity
                    font.family: AsemanApp.globalFont.family
                    text: model.name
                }
            }

            onClicked: {
                if(model.component) {
                    pageManager.append(model.component)
                    sidebar.discard()
                    Tools.jsDelayCall(500, function(){ sidebar.discard() })
                } else {
                    sidebar.discard()
                }
            }
        }

        Component.onCompleted: {
            TgChartsGlobals.translator.refreshed.connect(refresh)
            refresh()
        }
        function refresh() {
            model.clear()
            model.append({"name": qsTr("Home")   , "icon": Awesome.fa_home, "component": null})
            model.append({"name": qsTr("Settings"), "icon": Awesome.fa_gear, "component": configure_component})
            model.append({"name": qsTr("Contact"), "icon": Awesome.fa_mail_reply, "component": null})
            model.append({"name": qsTr("About")  , "icon": Awesome.fa_star, "component": null})
        }
    }

    Component {
        id: configure_component
        Pages.Configure {
            anchors.fill: parent
            engine: sideMenu.engine
        }
    }
}

/*
    Copyright (C) 2017 Aseman Team
    http://aseman.co

    TelegramStats is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    TelegramStats is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import AsemanTools 1.1
import AsemanTools.Awesome 1.0
import TelegramQml 2.0 as Telegram
import QtQuick.Controls 2.0 as QtControls
import QtGraphicalEffects 1.0
import "../authenticating" as Auth
import "../toolkit" as Toolkit
import "../pages" as Pages
import "../globals"

Rectangle {
    id: sideMenu
    clip: true

    property alias engine: profilePic.engine

    Rectangle {
        id: headRect
        width: parent.width
        height: 2*width/3
        color: TgChartsGlobals.masterColor

        Toolkit.ProfileImage {
            id: backImg
            anchors.fill: parent
            anchors.margins: -1*Devices.density
            radius: 0
            source: engine.our.user
            engine: profilePic.engine
            visible: false
        }

        FastBlur {
            source: backImg
            anchors.fill: backImg
            radius: 64*Devices.density
            cached: true

            Rectangle {
                color: TgChartsGlobals.backgroundColor
                opacity: 0.3
                anchors.fill: parent
            }
        }

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
                color: TgChartsGlobals.foregroundColor
                font.pixelSize: 10*Devices.fontDensity
                text: engine.our.user.firstName + " " + engine.our.user.lastName
            }

            QtControls.Label {
                color: TgChartsGlobals.foregroundColor
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
            model.append({"name": qsTr("Contact"), "icon": Awesome.fa_mail_reply, "component": contact_component})
            model.append({"name": qsTr("About")  , "icon": Awesome.fa_star, "component": about_component})
        }
    }

    Component {
        id: configure_component
        Pages.Configure {
            anchors.fill: parent
            engine: sideMenu.engine
        }
    }

    Component {
        id: contact_component
        Pages.Contact {
            anchors.fill: parent
            engine: sideMenu.engine
        }
    }

    Component {
        id: about_component
        Pages.About {
            anchors.fill: parent
        }
    }
}

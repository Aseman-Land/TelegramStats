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
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Awesome 2.0
import QtQuick.Controls 2.1 as QtControls
import QtQuick.Layouts 1.3 as QtLayouts
import TelegramQml 2.0 as Telegram
import QtQuick.Controls.Material 2.0
import QtGraphicalEffects 1.0
import "../toolkit" as Toolkit
import "../globals"

QtControls.Page {
    id: configure

    readonly property bool configurePage: true
    property alias engine: profilePic.engine

    AsemanFlickable {
        id: flick
        width: parent.width
        anchors.top: headRect.bottom
        anchors.bottom: parent.bottom
        contentWidth: sceneColumn.width
        contentHeight: sceneColumn.height

        Column {
            id: sceneColumn
            width: flick.width

            LayoutMirroring.childrenInherit: true
            LayoutMirroring.enabled: View.reverseLayout

            QtControls.ItemDelegate {
                width: parent.width
                height: 56*Devices.density
                hoverEnabled: false
                onClicked: TgChartsGlobals.darkMode = !TgChartsGlobals.darkMode

                QtLayouts.RowLayout {
                    width: parent.width - 40*Devices.density
                    anchors.centerIn: parent

                    QtControls.Label {
                        anchors.verticalCenter: parent.verticalCenter
                        color: TgChartsGlobals.foregroundColor
                        text: qsTr("Dark mode") + TgChartsGlobals.translator.refresher
                        font.pixelSize: 9*Devices.fontDensity
                        QtLayouts.Layout.fillWidth: true
                    }

                    QtControls.Switch {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width
                        checked: TgChartsGlobals.darkMode
                        onClicked: TgChartsGlobals.darkMode = !TgChartsGlobals.darkMode
                    }
                }
            }

            Item {
                width: parent.width
                height: 56*Devices.density

                QtLayouts.RowLayout {
                    width: parent.width - 40*Devices.density
                    anchors.centerIn: parent

                    QtControls.Label {
                        anchors.verticalCenter: parent.verticalCenter
                        color: TgChartsGlobals.foregroundColor
                        text: qsTr("Languages") + TgChartsGlobals.translator.refresher
                        font.pixelSize: 9*Devices.fontDensity
                        QtLayouts.Layout.fillWidth: true
                    }

                    QtControls.ComboBox {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width
                        model: [ "English", "فارسی" ]
                        onCurrentTextChanged: {
                            if(!inited) return
                            if(currentText == "English")
                                TgChartsGlobals.localeName = "en"
                            else
                            if(currentText == "فارسی")
                                TgChartsGlobals.localeName = "fa"
                        }
                        Component.onCompleted: {
                            if(TgChartsGlobals.localeName == "en")
                                currentIndex = 0
                            else
                            if(TgChartsGlobals.localeName == "fa")
                                currentIndex = 1
                            inited = true
                        }
                        property bool inited: false
                    }
                }
            }

            QtControls.ItemDelegate {
                width: parent.width
                height: 56*Devices.density
                hoverEnabled: false
                visible: !TgChartsGlobals.premium
                onClicked: premiumDialog.open()

                QtLayouts.RowLayout {
                    width: parent.width - 40*Devices.density
                    anchors.centerIn: parent

                    QtControls.Label {
                        anchors.verticalCenter: parent.verticalCenter
                        color: TgChartsGlobals.foregroundColor
                        text: qsTr("Active premium using code") + TgChartsGlobals.translator.refresher
                        font.pixelSize: 9*Devices.fontDensity
                        QtLayouts.Layout.fillWidth: true
                    }
                }
            }
        }
    }

    ScrollBar {
        scrollArea: flick; height: flick.height; anchors.right: flick.right; anchors.top: flick.top
        color: TgChartsGlobals.masterColor
        LayoutMirroring.enabled: View.layoutDirection == Qt.RightToLeft
    }

    Rectangle {
        id: headRect
        width: parent.width
        height: 170*Devices.density + Devices.statusBarHeight
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

        Item {
            width: parent.width
            y: Devices.statusBarHeight
            height: Devices.standardTitleBarHeight

            QtControls.Label {
                anchors.centerIn: parent
                font.pixelSize: 11*Devices.fontDensity
                color: TgChartsGlobals.foregroundColor
                text: qsTr("Settings") + TgChartsGlobals.translator.refresher
            }

            QtControls.Button {
                width: height
                height: parent.height
                anchors.right: View.defaultLayout? parent.right : undefined
                anchors.left: View.defaultLayout? undefined : parent.left
                font.family: Awesome.family
                font.pixelSize: 12*Devices.fontDensity
                text: Awesome.fa_ellipsis_v
                hoverEnabled: false
                flat: true
                Material.theme: TgChartsGlobals.darkMode? Material.Dark : Material.Light
                onClicked: optionsMenu.open()

                QtControls.Menu {
                    id: optionsMenu
                    x: View.defaultLayout? parent.width - width : 0
                    transformOrigin: View.defaultLayout? QtControls.Menu.TopRight : QtControls.Menu.TopLeft
                    modal: true

                    onVisibleChanged: {
                        if(visible)
                            BackHandler.pushHandler(optionsMenu, function(){visible = false})
                        else
                            BackHandler.removeHandler(optionsMenu)
                    }

                    QtControls.MenuItem {
                        text: qsTr("Logout")
                        font.family: AsemanApp.globalFont.family
                        font.pixelSize: 9*Devices.fontDensity
                        onTriggered: dialog.open()
                    }
                }
            }
        }

        Row {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 20*Devices.density
            spacing: 8*Devices.density

            Toolkit.ProfileImage {
                id: profilePic
                anchors.verticalCenter: parent.verticalCenter
                width: 64*Devices.density
                height: width
                source: engine.our.user
            }

            Column {
                spacing: 2*Devices.density
                anchors.verticalCenter: parent.verticalCenter

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
    }

    QtControls.Dialog {
        id: dialog
        title: qsTr("Logout") + TgChartsGlobals.translator.refresher
        standardButtons: QtControls.Dialog.Ok | QtControls.Dialog.Cancel
        x: parent.width/2 - width/2
        y: parent.height/2 - height/2
        modal: true
        dim: true
        closePolicy: QtControls.Popup.CloseOnPressOutside

        onVisibleChanged: {
            if(visible)
                BackHandler.pushHandler(this, function(){visible = false})
            else
                BackHandler.removeHandler(this)
        }

        QtControls.Label {
            font.pixelSize: 9*Devices.fontDensity
            text: qsTr("Do you realy want to logout?") + TgChartsGlobals.translator.refresher
        }

        onAccepted: {
            var obj = showGlobalWait( qsTr("Please Wait"), true )
            obj.color = TgChartsGlobals.backgroundColor

            configure.engine.logout()
            configure.engine.authLoggedOut.connect(function(){
                obj.destroy()
            })
            close()
        }

        onRejected: close()
    }

    QtControls.Dialog {
        id: premiumDialog
        title: qsTr("Active Premium") + TgChartsGlobals.translator.refresher
        contentHeight: premiumDialogColumn.height
        contentWidth: premiumDialogColumn.width
        x: parent.width/2 - width/2
        y: parent.height/2 - height/2
        modal: true
        dim: true
        closePolicy: QtControls.Popup.CloseOnPressOutside

        onVisibleChanged: {
            if(visible)
                BackHandler.pushHandler(this, function(){visible = false})
            else
                BackHandler.removeHandler(this)
        }

        footer: QtControls.DialogButtonBox {
            QtControls.Button {
                text: qsTr("Active") + TgChartsGlobals.translator.refresher
                flat: true
                onClicked: {
                    var res = TgChartsStore.activePremiumUsingCode(codeField.text)
                    if(res) {
                        premiumDialog.close()
                        showTooltip( qsTr("Premium activated :)") )
                    } else {
                        showTooltip( qsTr("Wrong code :/") )
                    }
                }
            }
            QtControls.Button {
                text: qsTr("Cancel") + TgChartsGlobals.translator.refresher
                flat: true
                onClicked: premiumDialog.close()
            }
        }

        Column {
            id: premiumDialogColumn

            QtControls.Label {
                id: label
                font.pixelSize: 9*Devices.fontDensity
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: qsTr("To active premium, enter the code below:") + TgChartsGlobals.translator.refresher
            }

            QtControls.TextField {
                id: codeField
                width: parent.width
                placeholderText: qsTr("Active code") + TgChartsGlobals.translator.refresher
                inputMethodHints: Qt.ImhNoPredictiveText
            }
        }
    }
}

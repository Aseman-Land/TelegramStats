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
import QtQuick.Controls.Material 2.1
import "../globals"
import "../charts" as Charts

Item {
    id: fchartBtn
    height: 80*Devices.density

    property variant dataMap
    property alias refreshing: indicator.running

    Item {
        id: scene
        anchors.fill: parent

        QtControls.Button {
            anchors.fill: parent
            anchors.topMargin: 8*Devices.density
            anchors.bottomMargin: 4*Devices.density
            anchors.margins: 8*Devices.density
            highlighted: true
            hoverEnabled: false

            Material.accent: TgChartsGlobals.masterColor // "#FF5722"

            onClicked: {
                if(indicator.running)
                    return
                var dlg = selector_component.createObject(fchartBtn)
                dlg.open()
            }

            QtControls.Label {
                anchors.centerIn: parent
                text: qsTr("Best friends Challenge") + TgChartsGlobals.translator.refresher
                font.pixelSize: 11*Devices.fontDensity
                color: "#ffffff"
                visible: !indicator.running
            }

            QtControls.BusyIndicator {
                id: indicator
                anchors.centerIn: parent
                height: 64*Devices.density
                width: height
                transformOrigin: Item.Center
                scale: 0.5
                Material.accent: "#ffffff"
            }
        }
    }

    PointMapListener {
        id: pntListener
        source: fchartBtn
    }

    Component {
        id: selector_component
        QtControls.Dialog {
            id: dialog
//            title: qsTr("Your top active chats")
            contentHeight: backColumn.height + 20*Devices.density
            contentWidth: backColumn.width
            x: parent.width/2 - width/2
            y: View.root.height/2 - height/2 - pntListener.result.y
            modal: true
            dim: true
            closePolicy: QtControls.Popup.CloseOnPressOutside
            leftPadding: 0
            topPadding: 0
            rightPadding: 0
            bottomPadding: 0

            onVisibleChanged: {
                if(visible)
                    BackHandler.pushHandler(this, function(){visible = false})
                else {
                    BackHandler.removeHandler(this)
                    Tools.jsDelayCall(400, dialog.destroy)
                }
            }

            footer: QtControls.DialogButtonBox {
                QtControls.Button {
                    text: qsTr("Share") + TgChartsGlobals.translator.refresher
                    flat: true
                    onClicked: {
                        swipe.currentItem.share().shareCompleted.connect(dialog.close)
                    }
                }
                QtControls.Button {
                    text: qsTr("Close") + TgChartsGlobals.translator.refresher
                    flat: true
                    onClicked: dialog.close()
                }
            }

            Column {
                id: backColumn
                width: {
                    var res = fchartBtn.width - 20*Devices.density
                    if(res > 500*Devices.density)
                        res = 500*Devices.density
                    return res
                }

                TabBar {
                    id: tabbar
                    width: parent.width
                    model: [qsTr("Challenge"), qsTr("Full Chart")]
                    highlightColor: TgChartsGlobals.masterColor
                    color: TgChartsGlobals.backgroundAlternativeColor
                    textColor: TgChartsGlobals.foregroundColor
                    fontSize: 10*Devices.fontDensity
                    currentIndex: 0
                    onCurrentIndexChanged: if(swipe) swipe.currentIndex = currentIndex
                }

                QtControls.SwipeView {
                    id: swipe
                    width: parent.width
                    height: width*4/5
                    clip: true
                    onCurrentIndexChanged: tabbar.currentIndex = currentIndex

                    LayoutMirroring.enabled: View.reverseLayout
                    LayoutMirroring.childrenInherit: true

                    Charts.CupChart {
                        width: swipe.width
                        height: swipe.height
                        dataMap: fchartBtn.dataMap
                        LayoutMirroring.childrenInherit: false
                    }

                    Charts.CompareAllChart {
                        width: swipe.width
                        height: swipe.height
                        dataMap: fchartBtn.dataMap
                        LayoutMirroring.childrenInherit: false
                    }
                }
            }

            onRejected: close()
        }
    }
}

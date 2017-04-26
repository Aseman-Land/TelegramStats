import QtQuick 2.0
import AsemanTools 1.1
import AsemanTools.Awesome 1.0
import TelegramQml 2.0 as Telegram
import QtQuick.Controls 2.0 as QtControls
import QtQuick.Controls.Material 2.0
import "../authenticating" as Auth
import "../globals"
import "../toolkit" as Toolkit

QtControls.Page {

    property alias engine: dmodel.engine
    property ChartList currentList

    property alias searchVisible: searchAction.active

    Telegram.DialogListModel {
        id: dmodel
        visibility: Telegram.DialogListModel.VisibilityUsers
    }

    AsemanGridView {
        id: dlist
        width: parent.width
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        model: dmodel

        cellWidth: parent.width/Math.floor(dlist.width/(128*Devices.density))
        cellHeight: cellWidth + 25*Devices.density

        delegate: Item {
            width: dlist.cellWidth
            height: dlist.cellHeight

            Rectangle {
                anchors.fill: parent
                anchors.margins: 1*Devices.density
                border.color: "#efefef"
                border.width: 1*Devices.density
                radius: 5*Devices.density

                Item {
                    y: x
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width - 16*Devices.density
                    height: parent.height - 16*Devices.density

                    Toolkit.ProfileImage {
                        width: parent.width
                        height: width
                        radius: 0
                        engine: dmodel.engine
                        source: model.peer
                    }

                    QtControls.Label {
                        width: parent.width
                        text: model.title
                        anchors.bottom: parent.bottom
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 9*Devices.fontDensity
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        maximumLineCount: 1
                        elide: Text.ElideRight
                    }
                }

                QtControls.ItemDelegate {
                    anchors.fill: parent
                    onClicked: {
                        if(currentList)
                            return

                        currentList = pageManager.append(chart_component, {"title": model.title, "peer": model.peer})
                        discardSearchFocus()
                    }
                }
            }
        }
    }

    ScrollBar {
        scrollArea: dlist; height: dlist.height; anchors.right: dlist.right; anchors.top: dlist.top
        color: TgChartsGlobals.masterColor
        LayoutMirroring.enabled: View.layoutDirection == Qt.RightToLeft
    }

    Header {
        id: header
        width: parent.width
        text: qsTr("Telegram Charts")
        color: TgChartsGlobals.masterColor

        MaterialFrame {
            id: searchFrame
            width: parent.width - 20*Devices.density
            x: 10*Devices.density
            height: Devices.standardTitleBarHeight - 20*Devices.density
            y: Devices.statusBarHeight + (Devices.standardTitleBarHeight-height)/2
            visible: searchAction.active
            onVisibleChanged: {
                if(visible) {
                    textField.forceActiveFocus()
                } else {
                    textField.text = ""
                    textField.focus = false
                }
            }

            BackAction {
                id: searchAction
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.IBeamCursor
                onClicked: textField.forceActiveFocus()
            }

            TextInput {
                id: textField
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height
                width: parent.width - Devices.standardTitleBarHeight
                x: View.defaultLayout? Devices.standardTitleBarHeight/2 + 10*Devices.density : 10*Devices.density
                font.pixelSize: 9*Devices.fontDensity
                font.family: AsemanApp.globalFont.family
                verticalAlignment: TextInput.AlignVCenter
                horizontalAlignment: View.defaultLayout? Text.AlignLeft : Text.AlignRight
                selectionColor: "#0d80ec"
                selectByMouse: true
                color: TgChartsGlobals.foregroundColor
                inputMethodHints: {
                    var deviceName = Devices.deviceName.toLowerCase()
                    if(deviceName.indexOf("htc") >= 0 || deviceName.indexOf("huawei") >= 0)
                        return Qt.ImhNone
                    else
                        return Qt.ImhNoPredictiveText
                }

                Text {
                    anchors.fill: parent
                    font: textField.font
                    verticalAlignment: Text.AlignVCenter
                    color: "#888888"
                    text: qsTr("Search")
                    visible: textField.text.length == 0
                }

                onTextChanged: refresh()
            }
        }

        Button {
            y: View.statusBarHeight + xMargin
            x: View.defaultLayout? parent.width - xMargin - width : xMargin
            height: Devices.standardTitleBarHeight - 2*xMargin
            width: height
            text: searchVisible? Awesome.fa_close : Awesome.fa_search
            fontSize: 12*Devices.fontDensity
            textFont.family: Awesome.family
            textColor: searchFrame.visible? "#888888" : "#ffffff"
            highlightColor: "#44ffffff"
            radius: 4*Devices.density
            onClicked: {
                if(searchVisible)
                    textField.text = ""
                else
                    searchAction.active = true
            }

            property real xMargin: 10*Devices.density
        }
    }

    Timer {
        id: delayTimer
        interval: 500
        repeat: false
        onTriggered: {
            dmodel.filter = textField.text
        }
    }

    Component {
        id: chart_component
        ChartList {
            anchors.fill: parent
            engine: dmodel.engine
        }
    }

    function refresh() {
        delayTimer.restart()
    }

    function discardSearchFocus() {
        textField.focus = false
    }
}

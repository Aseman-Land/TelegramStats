import QtQuick 2.0
import AsemanTools 1.1
import TelegramQml 2.0 as Telegram
import QtQuick.Controls 2.0 as QtControls
import QtQuick.Controls.Material 2.0
import "../authenticating" as Auth
import "../globals"
import "../toolkit" as Toolkit

QtControls.Page {

    property alias engine: dmodel.engine

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
                        pageManager.append(chart_component, {"title": model.title, "peer": model.peer})
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
    }

    Component {
        id: chart_component
        ChartList {
            anchors.fill: parent
            engine: dmodel.engine
        }
    }
}

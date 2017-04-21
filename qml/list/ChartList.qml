import AsemanTools 1.1
import AsemanTools.Awesome 1.0
import TelegramQml 2.0
import QtQuick 2.0
import TgChart 1.0 as TgChart
import QtQuick.Controls 2.0 as QtControls
import QtQuick.Controls.Material 2.0
import QtCharts 2.1
import "../authenticating" as Auth
import "../charts" as Charts
import "../globals"
import "../toolkit" as Toolkit

QtControls.Page {
    id: page

    property alias engine: profilePic.engine
    property InputPeer peer

    TgChart.Engine {
        id: chartEngine
        offset: 0
        limit: 100000
        telegram: page.engine? page.engine.telegramObject : null
        peer: page.peer
        dataDirectory: TgChartsGlobals.profilePath + "/messages.sqlite"
    }

    ItemGrabber {
        id: grabber
        item: chartBack
        onSaved: {
            Tools.jsDelayCall(1000, function(){
                grabber.waitObj.destroy()
                Qt.openUrlExternally( Devices.localFilesPrePath + dest)
            })
        }

        property variant waitObj
    }

    AsemanFlickable {
        id: flick
        width: parent.width
        anchors.top: blackBar.bottom
        anchors.bottom: parent.bottom
        anchors.topMargin: -pictureRow.height - pictureRow.y
        contentWidth: flick.width
        contentHeight: column.height

        Rectangle {
            id: chartBack
            width: column.width
            height: column.height
            color: TgChartsGlobals.backgroundColor

            Column {
                id: column
                width: flick.width
                spacing: 8*Devices.density

                Item { width: 1; height: 8*Devices.density }

                Row {
                    id: pictureRow
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 8*Devices.density
                    layoutDirection: View.layoutDirection

                    Toolkit.ProfileImage {
                        width: 64*Devices.density
                        height: width
                        source: page.engine.our.user
                        engine: page.engine
                    }

                    QtControls.Label {
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 16*Devices.fontDensity
                        font.family: Awesome.family
                        text: Awesome.fa_exchange
                        opacity: 0.7
                        color: TgChartsGlobals.masterColor
                    }

                    Toolkit.ProfileImage {
                        id: profilePic
                        width: 64*Devices.density
                        height: width
                        source: page.peer
                    }
                }

                QtControls.Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("All send and recieved messages")
                    font.pixelSize: 12*Devices.fontDensity
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 8*Devices.density

                    QtControls.Label {
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 18*Devices.fontDensity
                        font.family: Awesome.family
                        text: Awesome.fa_comments
                        color: TgChartsGlobals.masterColor
                    }

                    QtControls.Label {
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 15*Devices.fontDensity
                        text: chartEngine.count
                    }
                }

                MaterialFrame {
                    width: parent.width - 20*Devices.density
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: width*9/16

                    Charts.DayChart {
                        anchors.fill: parent
                        engine: chartEngine
                        peerName: page.title
                    }
                }

                Charts.EmojiChart {
                    width: parent.width - 20*Devices.density
                    anchors.horizontalCenter: parent.horizontalCenter
                    engine: chartEngine
                    peerName: page.title
                }

                MaterialFrame {
                    width: parent.width - 20*Devices.density
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: width*9/16

                    Charts.MonthChart {
                        anchors.fill: parent
                        engine: chartEngine
                        peerName: page.title
                    }
                }

                MaterialFrame {
                    width: parent.width - 20*Devices.density
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: width*16/16

                    Charts.FileChart {
                        anchors.fill: parent
                        engine: chartEngine
                        peerName: page.title
                    }
                }

                MaterialFrame {
                    width: parent.width - 20*Devices.density
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: width*9/16

                    Charts.TimeChart {
                        anchors.fill: parent
                        engine: chartEngine
                        peerName: page.title
                    }
                }

                MaterialFrame {
                    width: parent.width - 20*Devices.density
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: width*9/16

                    Charts.SendSumChart {
                        anchors.fill: parent
                        engine: chartEngine
                        peerName: page.title
                    }
                }

                Item { width: 1; height: 8*Devices.density }
            }
        }
    }

    ScrollBar {
        scrollArea: flick; height: flick.height; anchors.right: flick.right; anchors.top: flick.top
        color: TgChartsGlobals.masterColor
        LayoutMirroring.enabled: View.layoutDirection == Qt.RightToLeft
    }

    Header {
        id: header
        width: parent.width
        color: TgChartsGlobals.masterColor

        Item {
            width: parent.width
            height: Devices.standardTitleBarHeight
            anchors.bottom: parent.bottom

            QtControls.BusyIndicator {
                id: indicator
                anchors.right: parent.right
                anchors.rightMargin: y
                anchors.verticalCenter: parent.verticalCenter
                height: 54*Devices.density
                width: height
                running: chartEngine.refreshing
                transformOrigin: Item.Center
                scale: 0.5
                Material.accent: "#ffffff"
            }

            QtControls.Button {
                width: height
                height: parent.height
                anchors.right: parent.right
                font.family: Awesome.family
                font.pixelSize: 12*Devices.fontDensity
                text: Awesome.fa_share
                visible: !indicator.running
                flat: true
                Material.theme: Material.Dark
                onClicked: {
                    if(grabber.waitObj)
                        return
                    grabber.waitObj = showGlobalWait( qsTr("Please Wait"), true )
                    grabber.save("/sdcard/Download/TelegramCharts", Qt.size(chartBack.width*2, chartBack.height*2))
                }
            }
        }
    }

    Rectangle {
        id: blackBar
        width: parent.width
        anchors.top: header.bottom
        height: Devices.standardTitleBarHeight*0.8
        color: "#222222"

        Toolkit.ProfileImage {
            id: blackProfilePic
            width: Devices.standardTitleBarHeight*1.2
            height: width
            source: page.peer
            engine: profilePic.engine
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: height*0.3
        }

        QtControls.Label {
            anchors.right: blackProfilePic.left
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            color: "#ffffff"
            text: page.title
            horizontalAlignment: Text.AlignRight
            font.pixelSize: 9*Devices.fontDensity
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            maximumLineCount: 1
        }

        QtControls.Label {
            anchors.left: blackProfilePic.right
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignLeft
            color: "#ffffff"
            text: qsTr("%1 messages").arg(chartEngine.count)
            font.pixelSize: 9*Devices.fontDensity
            wrapMode: Text.WrapAnywhere
            maximumLineCount: 1
        }

        Rectangle {
            anchors.fill: progress
            visible: progress.visible
            color: "#ffffff"
            opacity: 0.3
        }

        QtControls.ProgressBar {
            id: progress
            width: parent.width
            visible: chartEngine.refreshing
            anchors.bottom: parent.bottom
            value: chartEngine.loadedCount
            from: 0; to: chartEngine.count
        }
    }
}

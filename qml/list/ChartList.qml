import AsemanTools 1.1
import AsemanTools.Awesome 1.0
import TelegramQml 2.0
import QtQuick 2.7
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
        dataDirectory: TgChartsGlobals.profilePath + "/messages.sqlite"
    }

    Timer {
        interval: 400
        onTriggered: chartEngine.peer = page.peer
        repeat: false
        Component.onCompleted: restart()
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
        contentHeight: grid.height

        Rectangle {
            id: chartBack
            width: grid.width
            height: grid.height
            color: TgChartsGlobals.backgroundColor

            Grid {
                id: grid
                width: flick.width
                spacing: 8*Devices.density
                horizontalItemAlignment: Grid.AlignHCenter
                verticalItemAlignment: Grid.AlignVCenter
                leftPadding: columnSpacing
                rightPadding: leftPadding
                topPadding: leftPadding
                bottomPadding: leftPadding
                rowSpacing: columnSpacing
                columnSpacing: 10*Devices.density
                flow: Grid.LeftToRight
                columns: {
                    var res = Math.floor(width/(300*Devices.density))
                    if(res < 1)
                        res = 1
                    return res
                }

                property real cellWidth: width/columns - columnSpacing*2

                Row {
                    id: pictureRow
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
                    text: qsTr("All send and recieved messages")
                    font.pixelSize: 12*Devices.fontDensity
                }

                Row {
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
                    width: grid.cellWidth
                    height: width*9/16

                    Charts.DayChart {
                        id: dayChart
                        anchors.fill: parent
                        engine: chartEngine
                        peerName: page.title
                    }
                }

                MaterialFrame {
                    width: grid.cellWidth
                    height: emojiChart.height

                    Charts.EmojiChart {
                        id: emojiChart
                        width: grid.cellWidth
                        engine: chartEngine
                        peerName: page.title
                    }
                }

                MaterialFrame {
                    width: grid.cellWidth
                    height: width*9/16

                    Charts.MonthChart {
                        id: monthChart
                        anchors.fill: parent
                        engine: chartEngine
                        peerName: page.title
                    }
                }

                MaterialFrame {
                    width: grid.cellWidth
                    height: width*14/16

                    Charts.FileChart {
                        anchors.fill: parent
                        engine: chartEngine
                        peerName: page.title
                    }
                }

                MaterialFrame {
                    width: grid.cellWidth
                    height: detailsChart.height

                    Charts.MessageDetailsChart {
                        id: detailsChart
                        width: grid.cellWidth
                        engine: chartEngine
                        peerName: page.title
                        telegramEngine: page.engine
                        telegramPeer: page.peer
                    }
                }

                MaterialFrame {
                    width: grid.cellWidth
                    height: width*16/16

                    Charts.TimePolarChart {
                        anchors.fill: parent
                        engine: chartEngine
                        peerName: page.title
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
                text: Awesome.fa_ellipsis_v
                visible: !indicator.running
                flat: true
                Material.theme: Material.Dark
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
                        text: qsTr("Share")
                        font.family: AsemanApp.globalFont.family
                        font.pixelSize: 9*Devices.fontDensity
                        onTriggered: share()
                    }
                    QtControls.MenuItem {
                        text: qsTr("Clear Cache")
                        font.family: AsemanApp.globalFont.family
                        font.pixelSize: 9*Devices.fontDensity
                        onTriggered: {
                            chartEngine.clear()
                            chartEngine.refresh()
                        }
                    }
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

    function share() {
        if(grabber.waitObj)
            return

        grabber.waitObj = showGlobalWait( qsTr("Please Wait"), true )
        grabber.save(Devices.picturesLocation + "/TelegramCharts", Qt.size(chartBack.width*2, chartBack.height*2))
    }
}

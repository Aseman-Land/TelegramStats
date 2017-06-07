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

    property bool takingImage: false

    readonly property bool locked: {
        if(TgChartsGlobals.premium)
            return false

        var idx
        if(TgChartsGlobals.topChats) {
            idx = TgChartsGlobals.topChats.indexOf(peer.userId + "")
            if(idx >= 1 && idx < 4)
                return false
        }
        if(TgChartsGlobals.unlockedChats) {
            idx = TgChartsGlobals.unlockedChats.indexOf(peer.userId + "")
            if(idx != -1)
                return false
        }

        return true
    }

    property variant premiumObject
    onLockedChanged: {
        if(locked) {
            if(!premiumObject) premiumObject = premiumItem_component.createObject(page)
        } else  {
            if(premiumObject) premiumObject.destroy()
        }
    }

    TgChart.Engine {
        id: chartEngine
        offset: 0
        limit: 100000
        telegram: page.engine && !page.locked? page.engine.telegramObject : null
        dataDirectory: engine.configDirectory + "/" + engine.phoneNumber + "/messages.sqlite"
    }

    MessageListModel {
        id: mmodel
        limit: 1
        useCache: false
        currentPeer: page.peer
        engine: page.engine
    }

    Timer {
        interval: 400
        onTriggered: chartEngine.peer = page.peer
        repeat: false
        Component.onCompleted: restart()
    }

    HashObject {
        id: dataHash

        function insertUnique(key, value) {
            remove(key)
            insert(key, value)
            hashWriter_timer.restart()
        }
    }

    Timer {
        id: hashWriter_timer
        interval: 2000
        repeat: false
        onTriggered: {
            var path = engine.cache.path + "/charts/" + Tools.md5(peer.userId)
            Tools.writeFile(path , dataHash.toMap(), true)

            var userHash = Tools.md5(engine.our.user.id)
            var peerHash = Tools.md5(peer.userId)
            AsemanServices.tgStats.setCharts(userHash, peerHash, dataHash.toMap(), null)
        }
    }

    ItemGrabber {
        id: grabber
        item: chartBack
        suffix: "jpg"
        onSaved: {
            takingImage = false

            Tools.jsDelayCall(1000, function(){
                if(grabber.toUser) {
                    var msg = qsTr("Hey! It's our telegram interactivity infographic, check it out!")
                    grabber.waitObj.text = qsTr("Sending photo...")
                    mmodel.sendFile(Enums.SendFileTypeDocument, Devices.localFilesPrePath + dest, null, null, msg, function(){
                        grabber.waitObj.destroy()
                        stickeritem.visible = true
                        Tools.deleteFile(dest)
                        showTooltip( qsTr("Message sent") )
                    })
                } else {
                    grabber.waitObj.destroy()
                    Qt.openUrlExternally( Devices.localFilesPrePath + dest)
                }
            })
        }

        property variant waitObj
        property bool toUser: false
    }

    AsemanFlickable {
        id: flick
        width: parent.width
        anchors.top: blackBar.bottom
        anchors.bottom: parent.bottom
        anchors.topMargin: -pictureRow.height - pictureRow.y
        contentWidth: flick.width
        contentHeight: chartBack.height

        Rectangle {
            id: chartBack
            width: flick.width
            height: column.height
            color: TgChartsGlobals.backgroundColor

            Column {
                id: column
                width: chartBack.width
                spacing: 8*Devices.density

                Item { width: 1; height: 10*Devices.density }

                Row {
                    id: pictureRow
                    spacing: 8*Devices.density
                    layoutDirection: View.layoutDirection
                    anchors.horizontalCenter: parent.horizontalCenter

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

                Toolkit.StickerItem {
                    id: stickeritem
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: !stickeritem.isNull || !takingImage
                    width: {
                        var res = flick.width - grid.spacing*2
                        if(res > 500*Devices.density)
                            res = 500*Devices.density
                        return res
                    }
                }

                Column {
                    width: stickeritem.width
                    spacing: 10*Devices.density
                    anchors.horizontalCenter: parent.horizontalCenter

                    QtControls.Label {
                        text: qsTr("All send and recieved messages")
                        font.pixelSize: 12*Devices.fontDensity
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Row {
                        spacing: 8*Devices.density
                        layoutDirection: View.layoutDirection
                        anchors.horizontalCenter: parent.horizontalCenter

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
                            text: Tools.trNums(chartEngine.count)
                        }
                    }
                }

                Flow {
                    id: grid
                    width: column.width
                    height: {
                        var clmns = new Array
                        var sum = 0
                        for(var i in children) {
                            var chld = children[i]
                            if(!chld.visible)
                                continue

                            sum += chld.height + spacing
                        }

                        var perColumn = sum/columns
                        var oprDone = false
                        while(!oprDone) {
                            oprDone = true
                            for(var i=0 ; i<columns; i++)
                                clmns[i] = 0

                            var columnIdx = 0
                            for(i in children) {
                                var chld = children[i]
                                if(!chld.visible)
                                    continue

                                var itemHeight = chld.height + spacing
                                if(perColumn < clmns[columnIdx] + itemHeight)
                                    columnIdx++
                                if(columnIdx >= columns) {
                                    oprDone = false
                                    perColumn += 20*Devices.density
                                    break
                                }

                                clmns[columnIdx] += itemHeight
                            }
                        }

                        var max = 0
                        for(i in clmns)
                            if(clmns[i] > max)
                                max = clmns[i]

                        return topPadding + max + bottomPadding
                    }
                    spacing: 8*Devices.density
                    layoutDirection: View.layoutDirection
                    leftPadding: spacing
                    rightPadding: leftPadding
                    topPadding: leftPadding
                    bottomPadding: leftPadding
                    flow: Flow.TopToBottom
                    property int columns: {
                        var res = Math.floor(flick.width/(350*Devices.density))
                        if(res < 1)
                            res = 1
                        return res
                    }

                    property real cellWidth: (width - spacing)/columns - spacing

                    MaterialFrame {
                        width: grid.cellWidth
                        height: width*3/4
                        color: TgChartsGlobals.backgroundColor
                        shadowColor: TgChartsGlobals.foregroundColor
                        visible: dayChart.checkBox.checked || !takingImage

                        Charts.DayChart {
                            id: dayChart
                            anchors.fill: parent
                            engine: chartEngine
                            peerName: page.title
                            checkBox.visible: !takingImage
                            onChartDataChanged: dataHash.insertUnique("dayChart", chartData)
                        }
                    }

                    MaterialFrame {
                        width: grid.cellWidth
                        height: emojiChart.height
                        color: TgChartsGlobals.backgroundColor
                        shadowColor: TgChartsGlobals.foregroundColor
                        visible: emojiChart.checkBox.checked || !takingImage

                        Charts.EmojiChart {
                            id: emojiChart
                            width: grid.cellWidth
                            engine: chartEngine
                            peerName: page.title
                            telegramEngine: page.engine
                            telegramPeer: page.peer
                            checkBox.visible: !takingImage
                            onChartDataChanged: dataHash.insertUnique("emojiChart", chartData)
                        }
                    }

                    MaterialFrame {
                        width: grid.cellWidth
                        height: width*3/4
                        color: TgChartsGlobals.backgroundColor
                        shadowColor: TgChartsGlobals.foregroundColor
                        visible: senseChart.checkBox.checked || !takingImage

                        Charts.SenseDiaryChart {
                            id: senseChart
                            anchors.fill: parent
                            engine: chartEngine
                            peerName: page.title
                            checkBox.visible: !takingImage
                            onChartDataChanged: dataHash.insertUnique("senseChart", chartData)
                        }
                    }

                    MaterialFrame {
                        width: grid.cellWidth
                        height: width*3/4
                        color: TgChartsGlobals.backgroundColor
                        shadowColor: TgChartsGlobals.foregroundColor
                        visible: false

                        Charts.SenseDailyDiaryChart {
                            id: senseDailyChart
                            anchors.fill: parent
                            engine: chartEngine
                            peerName: page.title
                            checkBox.visible: !takingImage
                            onChartDataChanged: dataHash.insertUnique("senseDailyChart", chartData)
                        }
                    }

                    MaterialFrame {
                        width: grid.cellWidth
                        height: width*3/4
                        color: TgChartsGlobals.backgroundColor
                        shadowColor: TgChartsGlobals.foregroundColor
                        visible: monthChart.checkBox.checked || !takingImage

                        Charts.MonthChart {
                            id: monthChart
                            anchors.fill: parent
                            engine: chartEngine
                            peerName: page.title
                            checkBox.visible: !takingImage
                            onChartDataChanged: dataHash.insertUnique("monthChart", chartData)
                        }
                    }

                    MaterialFrame {
                        width: grid.cellWidth
                        height: width*14/16
                        color: TgChartsGlobals.backgroundColor
                        shadowColor: TgChartsGlobals.foregroundColor
                        visible: fileChart.checkBox.checked || !takingImage

                        Charts.FileChart {
                            id: fileChart
                            anchors.fill: parent
                            engine: chartEngine
                            peerName: page.title
                            checkBox.visible: !takingImage
                            onChartDataChanged: dataHash.insertUnique("fileChart", chartData)
                        }
                    }

                    MaterialFrame {
                        width: grid.cellWidth
                        height: detailsChart.height
                        color: TgChartsGlobals.backgroundColor
                        shadowColor: TgChartsGlobals.foregroundColor
                        visible: detailsChart.checkBox.checked || !takingImage

                        Charts.MessageDetailsChart {
                            id: detailsChart
                            width: grid.cellWidth
                            engine: chartEngine
                            peerName: page.title
                            telegramEngine: page.engine
                            telegramPeer: page.peer
                            checkBox.visible: !takingImage
                            onChartDataChanged: dataHash.insertUnique("detailsChart", chartData)
                        }
                    }

                    MaterialFrame {
                        width: grid.cellWidth
                        height: width*16/16
                        color: TgChartsGlobals.backgroundColor
                        shadowColor: TgChartsGlobals.foregroundColor
                        visible: timeChart.checkBox.checked || !takingImage

                        Charts.TimePolarChart {
                            id: timeChart
                            anchors.fill: parent
                            engine: chartEngine
                            peerName: page.title
                            checkBox.visible: !takingImage
                            onChartDataChanged: dataHash.insertUnique("timeChart", chartData)
                        }
                    }
                }

                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: stickeritem.width
                    height: 175*width/1080
                    sourceSize: Qt.size(1.2*width, 1.2*height)
                    source: "../files/WaterMark.png"
                    fillMode: Image.PreserveAspectFit
                }

                QtControls.Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 9*Devices.fontDensity
                    color: TgChartsGlobals.masterColor
                    text: "aseman.co/tgstats"
                }

                Item { width: 1; height: 10*Devices.density }
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
        color: {
            if(colorAnalizer.color == "#000000")
                return TgChartsGlobals.masterColor
            else
                return colorAnalizer.color
        }

        ImageColorAnalizor {
            id: colorAnalizer
//            source: blackProfilePic.currentImage
            method: ImageColorAnalizor.MoreSaturation
        }

        Item {
            width: parent.width
            height: Devices.standardTitleBarHeight
            anchors.bottom: parent.bottom

            QtControls.BusyIndicator {
                id: indicator
                anchors.right: View.defaultLayout? parent.right : undefined
                anchors.left: View.defaultLayout? undefined : parent.left
                anchors.margins: y
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
                anchors.right: View.defaultLayout? parent.right : undefined
                anchors.left: View.defaultLayout? undefined : parent.left
                font.family: Awesome.family
                font.pixelSize: 12*Devices.fontDensity
                text: Awesome.fa_ellipsis_v
                visible: !indicator.running && !page.locked
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
                        text: qsTr("Share with %1").arg(page.title)
                        font.family: AsemanApp.globalFont.family
                        font.pixelSize: 9*Devices.fontDensity
                        onTriggered: share(true)
                    }
                    QtControls.MenuItem {
                        text: qsTr("Save")
                        font.family: AsemanApp.globalFont.family
                        font.pixelSize: 9*Devices.fontDensity
                        onTriggered: {
                            if(TgChartsGlobals.premium)
                                share(false)
                            else
                                premiumReqDialog.open()
                        }
                    }
//                    QtControls.MenuItem {
//                        text: qsTr("Clear Cache")
//                        font.family: AsemanApp.globalFont.family
//                        font.pixelSize: 9*Devices.fontDensity
//                        onTriggered: {
//                            chartEngine.clear()
//                            chartEngine.refresh()
//                        }
//                    }
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
        z: 10

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
            visible: !page.locked
            maximumLineCount: 1
        }

        QtControls.Label {
            anchors.left: blackProfilePic.right
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignLeft
            color: "#ffffff"
            text: !chartEngine.refreshing || chartEngine.count? qsTr("%1 messages").arg(chartEngine.count) : qsTr("Loading...")
            font.pixelSize: 9*Devices.fontDensity
            wrapMode: Text.WrapAnywhere
            visible: !page.locked
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

    function share(toUser) {
        if(grabber.waitObj)
            return

        takingImage = true

        grabber.toUser = toUser
        grabber.waitObj = showGlobalWait( qsTr("Please Wait"), true )
        grabber.waitObj.color = TgChartsGlobals.backgroundColor
        Tools.jsDelayCall(100, function(){
            var ratio = Devices.deviceDensity
            var resWidth = chartBack.width*ratio
            var resHeight = chartBack.height*ratio

            var path = Devices.picturesLocation + "/Telegram Stats"
            if(toUser)
                path = AsemanApp.homePath + "/temp"

            grabber.fileName = qsTr("Your telegram stats") + " - " + Tools.dateToMSec(new Date)
            grabber.save(path, Qt.size(resWidth, resHeight))
        })
    }

    Component {
        id: premiumItem_component
        Toolkit.PremiumNotifyItem {
            width: parent.width
            anchors.top: parent.top
            anchors.topMargin: blackBar.height + blackBar.y
            anchors.bottom: parent.bottom
            title: page.title
            messagesModel: mmodel
        }
    }

    Toolkit.PremiumRequiredDialog {
        id: premiumReqDialog
        anchors.fill: parent
    }
}

import QtQuick 2.7
import AsemanTools 1.1
import AsemanTools.Awesome 1.0
import TelegramQml 2.0 as Telegram
import TgChart 1.0 as TgChart
import QtQuick.Controls 2.1 as QtControls
import QtCharts 2.1
import "../globals"
import "../toolkit" as Toolkit

Item {
    id: page
    height: column.height + 20*Devices.density

    property ChartView chart
    property variant engine
    property string peerName

    property variant telegramEngine
    property variant telegramPeer

    property string sentVoice
    property string receivedVoice
    property string sentChars
    property string receivedChars
    property string sentFileSize
    property string receivedFileSize
    property string sentEmojis
    property string receivedEmojis
    property string sentMessages
    property string receivedMessages

    TgChart.MessageDetailsChart {
        id: senderRatio
        engine: page.engine
        onPointRequest: {
            var length = value.length
            var type = value.type
            var out = value.out

            var str = ""
            switch(type) {
            case TgChart.MessageDetailsChart.TypeVoiceDuration: {
                var second = (length%60)
                var minute = (length-second)/60
                if(minute > 10)
                    str = qsTr("%1 minutes").arg(minute)
                else
                    str = qsTr("%1 seconds").arg(length)

                if(out)
                    sentVoice = str
                else
                    receivedVoice = str
            }
                break;
            case TgChart.MessageDetailsChart.TypeMessageLength: {
                str = qsTr("%1 characters").arg(length)
                if(out)
                    sentChars = str
                else
                    receivedChars = str
            }
                break;
            case TgChart.MessageDetailsChart.TypeMediaSize: {
                var mediaSize = value.mediaSize
                if(mediaSize > 1024*1024)
                    str = Math.floor(10*mediaSize/(1024*1024))/10 + "MB"
                else
                if(mediaSize > 1024)
                    str = Math.floor(10*mediaSize/(1024))/10 + "KB"
                else
                    str = mediaSize + "B"

                if(out)
                    sentFileSize = str
                else
                    receivedFileSize = str
            }
                break;
            case TgChart.MessageDetailsChart.TypeEmojisCount: {
                str = qsTr("%1 emoji").arg(value.count)
                if(out)
                    sentEmojis = str
                else
                    receivedEmojis = str
            }
                break;
            case TgChart.MessageDetailsChart.TypeMessagesCount: {
                str = qsTr("%1 message").arg(value.count)
                if(out)
                    sentMessages = str
                else
                    receivedMessages = str
            }
                break;
            }
        }
        onClearRequest: {
            sentVoice = "N/A"
            receivedVoice = "N/A"
            sentChars = "N/A"
            receivedChars = "N/A"
            sentFileSize = "N/A"
            receivedFileSize = "N/A"
            sentEmojis = "N/A"
            receivedEmojis = "N/A"
            sentMessages = "N/A"
            receivedMessages = "N/A"
        }
    }

    Grid {
        id: column
        anchors.centerIn: parent
        spacing: 8*Devices.density
        rowSpacing: spacing
        horizontalItemAlignment: Grid.AlignHCenter
        verticalItemAlignment: Grid.AlignVCenter
        columns: 5

        Item { width: 1; height: 1 }

        Toolkit.ProfileImage {
            width: 32*Devices.density
            height: width
            source: telegramEngine.our.user
            engine: telegramEngine
        }

        QtControls.Label {
            font.pixelSize: 16*Devices.fontDensity
            font.family: Awesome.family
            color: TgChartsGlobals.masterColor
            text: Awesome.fa_exchange
        }

        Toolkit.ProfileImage {
            width: 32*Devices.density
            height: width
            source: telegramPeer
            engine: telegramEngine
        }

        Item { width: 1; height: 1 }


        Item { width: 1; height: 1 }

        QtControls.Label {
            font.pixelSize: 9*Devices.fontDensity
            text: qsTr("You")
        }

        Item { width: 1; height: 1 }

        QtControls.Label {
            font.pixelSize: 9*Devices.fontDensity
            text: peerName
        }

        Item { width: 1; height: 1 }


        QtControls.Label {
            font.pixelSize: 16*Devices.fontDensity
            font.family: Awesome.family
            color: TgChartsGlobals.masterColor
            text: Awesome.fa_comments
        }

        QtControls.Label {
            font.pixelSize: 9*Devices.fontDensity
            text: sentMessages
        }

        Item { width: 1; height: 1 }

        QtControls.Label {
            font.pixelSize: 9*Devices.fontDensity
            text: receivedMessages
        }

        QtControls.Label {
            font.pixelSize: 16*Devices.fontDensity
            font.family: Awesome.family
            color: "#00000000"
            text: Awesome.fa_comments
        }


        QtControls.Label {
            font.pixelSize: 16*Devices.fontDensity
            font.family: Awesome.family
            color: TgChartsGlobals.masterColor
            text: Awesome.fa_microphone
        }

        QtControls.Label {
            font.pixelSize: 9*Devices.fontDensity
            text: sentVoice
        }

        Item { width: 1; height: 1 }

        QtControls.Label {
            font.pixelSize: 9*Devices.fontDensity
            text: receivedVoice
        }

        QtControls.Label {
            font.pixelSize: 16*Devices.fontDensity
            font.family: Awesome.family
            color: "#00000000"
            text: Awesome.fa_microphone
        }


        QtControls.Label {
            font.pixelSize: 16*Devices.fontDensity
            font.family: Awesome.family
            color: TgChartsGlobals.masterColor
            text: Awesome.fa_pencil
        }

        QtControls.Label {
            font.pixelSize: 9*Devices.fontDensity
            text: sentChars
        }

        Item { width: 1; height: 1 }

        QtControls.Label {
            font.pixelSize: 9*Devices.fontDensity
            text: receivedChars
        }

        QtControls.Label {
            font.pixelSize: 16*Devices.fontDensity
            font.family: Awesome.family
            color: "#00000000"
            text: Awesome.fa_pencil
        }


        QtControls.Label {
            font.pixelSize: 16*Devices.fontDensity
            font.family: Awesome.family
            color: TgChartsGlobals.masterColor
            text: Awesome.fa_file
        }

        QtControls.Label {
            font.pixelSize: 9*Devices.fontDensity
            text: sentFileSize
        }

        Item { width: 1; height: 1 }

        QtControls.Label {
            font.pixelSize: 9*Devices.fontDensity
            text: receivedFileSize
        }

        QtControls.Label {
            font.pixelSize: 16*Devices.fontDensity
            font.family: Awesome.family
            color: "#00000000"
            text: Awesome.fa_file
        }


        QtControls.Label {
            font.pixelSize: 16*Devices.fontDensity
            font.family: Awesome.family
            color: TgChartsGlobals.masterColor
            text: Awesome.fa_smile_o
        }

        QtControls.Label {
            font.pixelSize: 9*Devices.fontDensity
            text: sentEmojis
        }

        Item { width: 1; height: 1 }

        QtControls.Label {
            font.pixelSize: 9*Devices.fontDensity
            text: receivedEmojis
        }

        QtControls.Label {
            font.pixelSize: 16*Devices.fontDensity
            font.family: Awesome.family
            color: "#00000000"
            text: Awesome.fa_smile_o
        }
    }

    Component.onCompleted: {
        ctimer.restart()
    }

    Timer {
        id: ctimer
        interval: 400
        repeat: false
        onTriggered: {
            senderRatio.engine = page.engine
        }
    }
}

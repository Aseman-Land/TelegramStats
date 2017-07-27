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

import QtQuick 2.5
import AsemanTools 1.1
import AsemanTools.Awesome 1.0
import TelegramQml 2.0 as Telegram
import TgChart 1.0 as TgChart
import Qt.labs.controls 1.0 as QtControls
import QtCharts 2.0
import "../globals"
import "../toolkit" as Toolkit

AbstractChart {
    id: page
    height: column.height + 20*Devices.density

    property variant telegramEngine
    property variant telegramPeer

    property alias chartData: senderRatio.chartData

    property string sentVoice: "N/A"
    property string receivedVoice: "N/A"
    property string sentChars: "N/A"
    property string receivedChars: "N/A"
    property string sentFileSize: "N/A"
    property string receivedFileSize: "N/A"
    property string sentEmojis: "N/A"
    property string receivedEmojis: "N/A"
    property string sentMessages: "N/A"
    property string receivedMessages: "N/A"

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
                    sentVoice = Tools.trNums(str)
                else
                    receivedVoice = Tools.trNums(str)
            }
                break;
            case TgChart.MessageDetailsChart.TypeMessageLength: {
                str = qsTr("%1 characters").arg(length)
                if(out)
                    sentChars = Tools.trNums(str)
                else
                    receivedChars = Tools.trNums(str)
            }
                break;
            case TgChart.MessageDetailsChart.TypeMediaSize: {
                var mediaSize = value.mediaSize
                if(mediaSize > 1024*1024)
                    str = qsTr("%1MB").arg(Math.floor(10*mediaSize/(1024*1024))/10)
                else
                if(mediaSize > 1024)
                    str = qsTr("%1KB").arg(Math.floor(10*mediaSize/(1024))/10)
                else
                    str = qsTr("%1B").arg(mediaSize)

                if(out)
                    sentFileSize = Tools.trNums(str)
                else
                    receivedFileSize = Tools.trNums(str)
            }
                break;
            case TgChart.MessageDetailsChart.TypeEmojisCount: {
                str = qsTr("%1 emoji").arg(value.count)
                if(out)
                    sentEmojis = Tools.trNums(str)
                else
                    receivedEmojis = Tools.trNums(str)
            }
                break;
            case TgChart.MessageDetailsChart.TypeMessagesCount: {
                str = qsTr("%1 message").arg(value.count)
                if(out)
                    sentMessages = Tools.trNums(str)
                else
                    receivedMessages = Tools.trNums(str)
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

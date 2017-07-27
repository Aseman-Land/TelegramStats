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

    TgChart.EmojisDiary {
        id: senderRatio
        onPointRequest: {
            var emoji = value.emoji
            var count = value.count
            var out = value.out

            if(out)
                repeaterOut.model.append({"emoji": emoji, "count": count})
            else
                repeaterIn.model.append({"emoji": emoji, "count": count})
        }
        onClearRequest: {
            repeaterIn.model.clear()
            repeaterOut.model.clear()
        }
    }

    Column {
        id: column
        anchors.centerIn: parent
        width: parent.width
        spacing: 10*Devices.density

        QtControls.Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Your senses")
            font.pixelSize: 12*Devices.fontDensity
        }

        Grid {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 12*Devices.density
            columns: 6

            Toolkit.ProfileImage {
                width: 32*Devices.density
                height: width
                source: telegramEngine.our.user
                engine: telegramEngine
                visible: repeaterIn.count
            }

            Repeater {
                id: repeaterOut
                model: ListModel{}
                Image {
                    height: 32*Devices.density
                    width: height
                    sourceSize: Qt.size(width*2, height*2)
                    source: {
                        var emoji = model.emoji
                        return CutegramEmojis.getLink(emoji,"72x72")
                    }
                }
            }

            Toolkit.ProfileImage {
                width: 32*Devices.density
                height: width
                source: telegramPeer
                engine: telegramEngine
                visible: repeaterOut.count
            }

            Repeater {
                id: repeaterIn
                model: ListModel{}
                Image {
                    height: 32*Devices.density
                    width: height
                    sourceSize: Qt.size(width*2, height*2)
                    source: {
                        var emoji = model.emoji
                        return CutegramEmojis.getLink(emoji,"72x72")
                    }
                }
            }
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

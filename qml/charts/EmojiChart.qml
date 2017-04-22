import QtQuick 2.0
import AsemanTools 1.1
import TgChart 1.0 as TgChart
import QtQuick.Controls 2.0 as QtControls
import QtCharts 2.1
import "../globals"

Item {
    id: page
    height: column.height + 20*Devices.density

    property variant engine
    property string peerName

    TgChart.EmojisDiary {
        id: senderRatio
        onPointRequest: {
            var emoji = value.emoji
            var count = value.count
            repeater.model.append({"emoji": emoji, "count": count})
        }
        onClearRequest: repeater.model.clear()
    }

    Column {
        id: column
        anchors.centerIn: parent
        width: parent.width
        spacing: 10*Devices.density

        QtControls.Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Most used Emojis")
            font.pixelSize: 12*Devices.fontDensity
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 12*Devices.density
            Repeater {
                id: repeater
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

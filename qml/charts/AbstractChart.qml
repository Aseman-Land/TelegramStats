import QtQuick 2.0
import TgChart 1.0
import QtCharts 2.1
import QtQuick.Controls 2.1 as QtControls
import "../globals"

Item {
    id: achart
    property ChartView chart
    property Engine engine
    property string peerName

    signal clicked()

    MouseArea {
        anchors.fill: parent
        z: 100
        onClicked: achart.clicked()
    }
}

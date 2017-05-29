import QtQuick 2.0
import TgChart 1.0
import AsemanTools 1.0
import QtCharts 2.1
import QtQuick.Controls 2.1 as QtControls
import "../globals"

Item {
    id: achart
    property ChartView chart
    property Engine engine
    property string peerName

    property alias checkBox: checkBox

    signal clicked()

    LayoutMirroring.childrenInherit: true
    LayoutMirroring.enabled: View.reverseLayout

    MouseArea {
        anchors.fill: parent
        z: 100
        onClicked: achart.clicked()
    }

    QtControls.CheckBox {
        id: checkBox
        x: View.defaultLayout? 0 : parent.width - width
        z: 110
        checked: true

        MouseArea {
            anchors.fill: parent
            visible: !TgChartsGlobals.premium
            onClicked: premiumReqDialog.open()
        }
    }
}

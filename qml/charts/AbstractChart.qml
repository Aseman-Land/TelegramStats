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

    property alias chartBack: grabber.item
    property string shareName: "telegram Stats"

    signal clicked()
    signal shareCompleted()

    LayoutMirroring.childrenInherit: true
    LayoutMirroring.enabled: View.reverseLayout

    ItemGrabber {
        id: grabber
        item: achart
        suffix: "png"
        onSaved: {
            Tools.jsDelayCall(1000, function(){
                grabber.waitObj.destroy()
                Qt.openUrlExternally( Devices.localFilesPrePath + dest)
            })
        }

        property variant waitObj
    }

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

    function share() {
        if(grabber.waitObj)
            return null

        grabber.waitObj = showGlobalWait( qsTr("Please Wait"), true )
        grabber.waitObj.color = TgChartsGlobals.backgroundColor
        Tools.jsDelayCall(100, function(){
            var ratio = Devices.deviceDensity
            var resWidth = chartBack.width*ratio
            var resHeight = chartBack.height*ratio

            var path = Devices.picturesLocation + "/Telegram Stats"

            grabber.fileName = shareName + " - " + Tools.dateToMSec(new Date)
            grabber.save(path, Qt.size(resWidth, resHeight))
        })

        return achart
    }
}

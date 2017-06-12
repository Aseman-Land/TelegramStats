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

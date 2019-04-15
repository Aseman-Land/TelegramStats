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
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Awesome 2.0
import TgChart 1.0 as TgChart
import QtCharts 2.1
import QtQuick.Controls 2.1 as QtControls
import QtGraphicalEffects 1.0
import "../globals"

AbstractChart {
    id: page
    chartBack: chartScene
    shareName: "challenge"

    checkBox.visible: false

    property variant dataMap

    onDataMapChanged: {
        var list = new Array
        var counter = 0
        var total = 0

        var dataMapLength = 0
        for(var dt in dataMap)
            dataMapLength++

        var limit = dataMapLength - 6
        for(var value in dataMap) {
            counter++
            if(counter < limit)
                continue;

            var name = dataMap[value]
            total += value*1
            list[list.length] = {"name": name, "value": value}
        }

        lmodel.clear()
        for(var i=list.length-1; i>=list.length-3; i--) {
            var d = list[i]
            var percent = Math.floor(100*d.value/total)
            lmodel.append( {"name": d.name, "value": d.value, "percent": percent} )
        }
    }

    ListModel {
        id: lmodel
    }

    AsemanFlickable {
        id: flick
        anchors.fill: parent
        contentWidth: chartScene.width
        contentHeight: chartScene.height
        clip: true
        z: 105

        Rectangle {
            id: chartScene
            width: flick.width
            height: column.height
            color: TgChartsGlobals.backgroundAlternativeColor

            Column {
                id: column
                anchors.horizontalCenter: parent.horizontalCenter
//                width: parent.width

                Item { width: 1; height: 10*Devices.density }

                QtControls.Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 20*Devices.fontDensity
                    text: qsTr("Best friends Challenge")
                    color: TgChartsGlobals.masterColor
                }

                Item { width: 1; height: 10*Devices.density }

                Repeater {
                    model: lmodel

                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: 80*Devices.density
                        layoutDirection: View.layoutDirection
                        spacing: 20*Devices.density

                        Item {
                            height: parent.height - 20*Devices.density
                            anchors.verticalCenter: parent.verticalCenter
                            width: height

                            Image {
                                id: cupImage
                                anchors.fill: parent
                                source: "../files/cup.png"
                                sourceSize: Qt.size(2*width, 2*height)
                                visible: index == 0

                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    height: parent.height*0.4
                                    text: index+1
                                    color: "#ffffff"
                                    verticalAlignment: Text.AlignVCenter
                                    font.pixelSize: 12*Devices.fontDensity
                                }
                            }

                            Colorize {
                                anchors.fill: source
                                source: cupImage
                                visible: index != 0
                                hue: {
                                    switch(index) {
                                    case 1:
                                        return 0
                                    case 2:
                                        return 30/255
                                    }
                                    return 0
                                }
                                saturation: {
                                    switch(index) {
                                    case 1:
                                        return 0
                                    case 2:
                                        return 0.2
                                    }
                                    return 0
                                }
                                lightness: {
                                    switch(index) {
                                    case 1:
                                        return 0.5
                                    case 2:
                                        return 0
                                    }
                                    return 0
                                }
                            }
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter

                            QtControls.Label {
                                font.pixelSize: 14*Devices.fontDensity
                                text: model.name
                            }

                            QtControls.Label {
                                font.pixelSize: 9*Devices.fontDensity
                                text: "%1 messages".arg(model.value)
                                opacity: 0.8
                            }
                        }

                        QtControls.Label {
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 30*Devices.fontDensity
                            text: model.percent + "%"
                            color: TgChartsGlobals.masterColor
                        }
                    }
                }

                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
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
}

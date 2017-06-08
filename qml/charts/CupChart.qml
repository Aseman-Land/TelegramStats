import QtQuick 2.0
import AsemanTools 1.1
import AsemanTools.Awesome 1.0
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
                width: parent.width
                onHeightChanged: console.debug(height)

                Item { width: 1; height: 10*Devices.density }

                QtControls.Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 30*Devices.fontDensity
                    text: qsTr("Challenge")
                    color: TgChartsGlobals.masterColor
                }

                Repeater {
                    model: lmodel
                    Item {
                        width: column.width - 20*Devices.density
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: 80*Devices.density

                        Row {
                            anchors.fill: parent
                            anchors.margins: 10*Devices.density
                            layoutDirection: View.layoutDirection
                            spacing: 20*Devices.density

                            Item {
                                height: parent.height
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
                                        text: index
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
                                    font.pixelSize: 12*Devices.fontDensity
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

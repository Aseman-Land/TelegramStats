import QtQuick 2.0
import AsemanTools 1.1
import AsemanTools.Awesome 1.0
import TgChart 1.0 as TgChart
import QtCharts 2.1
import QtQuick.Controls 2.1 as QtControls
import "../globals"

AbstractChart {
    id: page
    shareName: "compare charts"

    checkBox.visible: false

    property variant dataMap
    property variant series
    property variant colors: ["#F44336", "#9C27B0", "#009688", "#3F51B5", "#795548", "#2196F3", "#FF5722", "#8BC34A", "#607D8B", "#FF9800"]

    onDataMapChanged: {
        if(series) chart.removeSeries(series)
        series = chart.createSeries(ChartView.SeriesTypePie, qsTr("Sum"), xAxis, yAxis);
        series.size = 1

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
            var color = colors[counter%10]
            list[list.length] = {"name": name, "color": color, "value": value}
        }

        for(var i=list.length-1; i>=0; i--) {
            var d = list[i]
            var percent = Math.floor(100*d.value/total)
            var slice = series.append("%1 %2%".arg(d.name).arg(percent), d.value)
            slice.color = d.color
            slice.labelVisible = (percent >= 10)
//            slice.label = "%1%".arg(percent)
            slice.labelPosition = PieSlice.LabelInsideHorizontal
            slice.labelFont.pixelSize = 5*Devices.fontDensity
            slice.labelColor = "#ffffff"
        }
    }

    ValueAxis {
        id: xAxis
        color: TgChartsGlobals.foregroundColor
        labelsColor: TgChartsGlobals.foregroundColor
    }

    ValueAxis {
        id: yAxis
        color: TgChartsGlobals.foregroundColor
        labelsColor: TgChartsGlobals.foregroundColor
    }

    Rectangle {
        anchors.fill: parent
        color: TgChartsGlobals.backgroundAlternativeColor
    }

    ChartView {
        id: chart
        anchors.fill: parent
        margins.left: 0
        margins.right: 0
        margins.bottom: 0
        margins.top: 0
        antialiasing: true
        legend.alignment: Qt.AlignLeft
        legend.font.pixelSize: 7*Devices.fontDensity
        titleFont.pixelSize: 11*Devices.fontDensity
        legend.labelColor: TgChartsGlobals.foregroundColor
        legend.visible: true
        backgroundColor: TgChartsGlobals.backgroundAlternativeColor
        titleColor: TgChartsGlobals.foregroundColor
        plotAreaColor: TgChartsGlobals.backgroundAlternativeColor
    }
}

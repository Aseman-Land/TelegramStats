import QtQuick 2.0
import AsemanTools 1.1
import AsemanTools.Awesome 1.0
import TgChart 1.0 as TgChart
import QtCharts 2.1
import QtQuick.Controls 2.1 as QtControls
import "../globals"

AbstractChart {
    id: page

    property variant dataMap
    property variant series
    property variant colors: ["#F44336", "#9C27B0", "#009688", "#3F51B5", "#795548", "#2196F3", "#FF5722", "#8BC34A", "#607D8B", "#FF9800"]

    onDataMapChanged: {
        if(series) chart.removeSeries(series)
        series = chart.createSeries(ChartView.SeriesTypePie, qsTr("Sum"), xAxis, yAxis);
        series.size = 1

        var counter = 0
        for(var value in dataMap) {
            counter++
            if(counter < 10)
                continue;

            var name = dataMap[value]
            var color = colors[counter%10]
            series.append("%1 (%2)".arg(name).arg(value), value).color = color
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
        backgroundColor: TgChartsGlobals.backgroundColor
        titleColor: TgChartsGlobals.foregroundColor
        plotAreaColor: TgChartsGlobals.backgroundColor
    }
}

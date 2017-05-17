import QtQuick 2.0
import AsemanTools 1.1
import TgChart 1.0 as TgChart
import QtCharts 2.1
import "../globals"

AbstractChart {
    id: page

    property int slice: 3

    TgChart.DailyTimeChart {
        id: senderRatio
        engine: chart? page.engine : null
        onPointRequest: {
            var y = value.count
            var x = value.time

            var newMax = y*1.2
            if(yAxis.max < newMax)
                yAxis.max = newMax

            senderRatio.series.append(x, y)
            senderRatio.scatter.append(x, y)

            if(x == 0)
                startPoint = y
            if(x == 23) {
                senderRatio.series.append(24, startPoint)
                senderRatio.scatter.append(24, startPoint)
            }
        }
        onClearRequest: {
            if(senderRatio.series) chart.removeSeries(senderRatio.series)
            senderRatio.series = chart.createSeries(ChartView.SeriesTypeSpline, qsTr("Sum"), xAxis, yAxis);

            if(senderRatio.scatter) chart.removeSeries(senderRatio.scatter)
            senderRatio.scatter = chart.createSeries(ChartView.SeriesTypeScatter, qsTr("Sum"), xAxis, yAxis);
            senderRatio.scatter.markerSize = 10*Devices.density
        }

        property variant series
        property variant scatter
        property int cache
        property real startPoint
    }

    ValueAxis {
        id: xAxis
        min: 0; max: 24
        tickCount: 25
        labelsFont.pixelSize: 6*Devices.fontDensity
        color: TgChartsGlobals.foregroundColor
        labelsColor: TgChartsGlobals.foregroundColor
    }

    ValueAxis {
        id: yAxis
        max: 10
        labelsFont.pixelSize: 6*Devices.fontDensity
        color: TgChartsGlobals.foregroundColor
        labelsColor: TgChartsGlobals.foregroundColor
    }

    Component {
        id: chart_component
        PolarChartView {
            id: chart
            anchors.fill: parent
            margins.left: 0
            margins.right: 0
            margins.bottom: 0
            margins.top: 0
            antialiasing: true
            legend.font.pixelSize: 7*Devices.fontDensity
            legend.visible: false
            titleFont.pixelSize: 11*Devices.fontDensity
            title: qsTr("Daily interaction")
            legend.labelColor: TgChartsGlobals.foregroundColor
            backgroundColor: TgChartsGlobals.backgroundColor
            titleColor: TgChartsGlobals.foregroundColor
            plotAreaColor: TgChartsGlobals.backgroundColor
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
            chart = chart_component.createObject(page)
        }
    }
}

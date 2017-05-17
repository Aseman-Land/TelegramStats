import QtQuick 2.0
import AsemanTools 1.1
import TgChart 1.0 as TgChart
import QtQuick.Controls 2.1 as QtControls
import QtCharts 2.1
import "page" as Page
import "../globals"

AbstractChart {
    id: page

    property alias average: timeDiary.average

//    onClicked: pageManager.append(page_component)

    TgChart.TimeDiaryChart {
        id: timeDiary
        day: true
        engine: chart? page.engine : null
        onPointRequest: {
            var outSum = value.outSum
            var y = value.y
            var x = value.x

            var xDate = Tools.mSecToDate(x)
            if(xDate < xAxis.min)
                return

            var log = 0
            var tmpY = y
            while(tmpY > 10) {
                tmpY = tmpY/10
                log++
            }

            var newMax = 100
            while(newMax < y)
                newMax += 100

            if(yAxis.max < newMax)
                yAxis.max = newMax

            seriesSum.append(x, y)
            seriesOut.append(x, outSum)
            seriesIn.append(x, y-outSum)

            if(max_updater_timer.max.y < y)
                max_updater_timer.max = Qt.point(x, y)

            max_updater_timer.restart()
        }
        onClearRequest: {
            if(seriesSum) chart.removeSeries(seriesSum)
            if(seriesOut) chart.removeSeries(seriesOut)
            if(seriesIn) chart.removeSeries(seriesIn)

            seriesSum = chart.createSeries(ChartView.SeriesTypeSpline, qsTr("Sum"), xAxis, yAxis);
            seriesOut = chart.createSeries(ChartView.SeriesTypeSpline, qsTr("You"), xAxis, yAxis);
            seriesIn  = chart.createSeries(ChartView.SeriesTypeSpline, peerName, xAxis, yAxis);

            seriesSum.pointLabelsColor = TgChartsGlobals.foregroundColor

        }

        property variant seriesSum
        property variant seriesOut
        property variant seriesIn
    }

    Timer {
        id: max_updater_timer
        interval: 100
        repeat: false
        onTriggered: {
            if(scatter) chart.removeSeries(scatter)
            scatter = chart.createSeries(ChartView.SeriesTypeScatter, qsTr("Max: %1 messages").arg(max.y), xAxis, yAxis);
            scatter.markerSize = 10*Devices.density
            scatter.append(max.x, max.y)
        }

        property variant scatter
        property point max
    }

    DateTimeAxis {
        id: xAxis
        labelsFont.pixelSize: 7*Devices.fontDensity
        min: {
            var today = new Date
            var day = today.getDay()
            var mnth = today.getMonth() - 2
            var year = today.getFullYear()
            if(mnth < 1) {
                mnth = 12
                year--
            }

            return new Date(year, mnth, day)
        }
        max: {
            var today = new Date
            var day = today.getDay()
            var mnth = today.getMonth()
            var year = today.getFullYear()
            mnth++
            if(mnth > 12) {
                mnth = 1
                year++
            }

            return Tools.dateAddDays(new Date, 4)
        }
        tickCount: 5
        format: "MMM dd"
        color: TgChartsGlobals.foregroundColor
        labelsColor: TgChartsGlobals.foregroundColor
    }

    ValueAxis {
        id: yAxis
        labelsFont.pixelSize: 7*Devices.fontDensity
        min: 0
        max: 10
        color: TgChartsGlobals.foregroundColor
        labelsColor: TgChartsGlobals.foregroundColor
    }

    QtControls.Label {
        id: avgLabel
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 4*Devices.density
        font.pixelSize: 8*Devices.fontDensity
        color: TgChartsGlobals.foregroundColor
        opacity: 0.8
        text: qsTr("%1 messages per day").arg(Math.floor(average))
        z: 100
    }

    Component {
        id: chart_component
        ChartView {
            id: chart
            anchors.fill: parent
            margins.left: 0
            margins.right: 0
            margins.bottom: avgLabel.height + avgLabel.anchors.bottomMargin
            margins.top: 0
            antialiasing: true
            title: qsTr("Your interaction based on the day")
            legend.font.pixelSize: 7*Devices.fontDensity
            titleFont.pixelSize: 11*Devices.fontDensity
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

    Component {
        id: page_component
        Page.DayChartPage {
            anchors.fill: parent
            engine: page.engine
            peerName: page.peerName
        }
    }
}

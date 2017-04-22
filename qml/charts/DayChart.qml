import QtQuick 2.0
import AsemanTools 1.1
import TgChart 1.0 as TgChart
import QtCharts 2.1
import "../globals"

Item {
    id: page

    property ChartView chart
    property variant engine
    property string peerName

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

            var newMax = Math.floor( y/(Math.pow(10, log)*2.5)+1 )*2.5
            newMax = newMax*Math.pow(10, log)

            if(yAxis.max < newMax)
                yAxis.max = newMax

            seriesSum.append(x, y)
            seriesOut.append(x, outSum)
            seriesIn.append(x, y-outSum)
        }
        onClearRequest: {
            if(seriesSum) chart.removeSeries(seriesSum)
            if(seriesOut) chart.removeSeries(seriesOut)
            if(seriesIn) chart.removeSeries(seriesIn)

            seriesSum = chart.createSeries(ChartView.SeriesTypeSpline, qsTr("Sum"), xAxis, yAxis);
            seriesOut = chart.createSeries(ChartView.SeriesTypeSpline, qsTr("You"), xAxis, yAxis);
            seriesIn  = chart.createSeries(ChartView.SeriesTypeSpline, peerName, xAxis, yAxis);
        }

        property variant seriesSum
        property variant seriesOut
        property variant seriesIn
    }

    DateTimeAxis {
        id: xAxis
        labelsFont.pixelSize: 7*Devices.fontDensity
        min: {
            var today = new Date
            var mnth = today.getMonth()
            var year = today.getFullYear()
            mnth--
            if(mnth < 1) {
                mnth = 12
                year--
            }

            return new Date(year, mnth, 1)
        }
        max: {
            var today = new Date
            var mnth = today.getMonth()
            var year = today.getFullYear()
            mnth++
            if(mnth > 12) {
                mnth = 1
                year++
            }

            return new Date(year, mnth, 1)
        }
        tickCount: 5
        format: "MMM dd"
    }

    ValueAxis {
        id: yAxis
        labelsFont.pixelSize: 7*Devices.fontDensity
        min: 0
        max: 10
    }

    Component {
        id: chart_component
        ChartView {
            id: chart
            anchors.fill: parent
            margins.left: 0
            margins.right: 0
            margins.bottom: 0
            margins.top: 0
            antialiasing: true
            title: qsTr("Your interaction based on the day")
            legend.font.pixelSize: 7*Devices.fontDensity
            titleFont.pixelSize: 11*Devices.fontDensity
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

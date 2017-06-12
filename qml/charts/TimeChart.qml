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
import AsemanTools 1.1
import TgChart 1.0 as TgChart
import QtCharts 2.1
import "../globals"

AbstractChart {
    id: page

    property alias chartData: senderRatio.chartData

    property variant catArray: new Array
    property variant sumArray: new Array

    property int slice: 3

    TgChart.DailyTimeChart {
        id: senderRatio
        engine: chart? page.engine : null
        onPointRequest: {
            var y = value.count
            var x = value.time
            if(x % slice != (slice-1)) {
                cache += y
                return
            }

            y += cache
            x = Math.floor(x/slice)
            cache = 0

            sumArray[x] = y

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

            updateTimer.restart()
        }

        property variant series
        property int cache
    }

    Timer {
        id: updateTimer
        interval: 500
        onTriggered: {
            if(senderRatio.series) chart.removeSeries(senderRatio.series)
            senderRatio.series = chart.createSeries(ChartView.SeriesTypeBar, qsTr("Sum"), xAxis, yAxis);
            xAxis.categories = catArray
            senderRatio.series.append(qsTr("Times"), sumArray)
        }
    }

    BarCategoryAxis {
        id: xAxis
        categories: catArray
        labelsFont.pixelSize: 6*Devices.fontDensity
        color: TgChartsGlobals.foregroundColor
        labelsColor: TgChartsGlobals.foregroundColor
    }

    ValueAxis {
        id: yAxis
        max: 1000
        labelsFont.pixelSize: 6*Devices.fontDensity
        color: TgChartsGlobals.foregroundColor
        labelsColor: TgChartsGlobals.foregroundColor
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
            legend.font.pixelSize: 7*Devices.fontDensity
            legend.visible: false
            titleFont.pixelSize: 11*Devices.fontDensity
            legend.labelColor: TgChartsGlobals.foregroundColor
            backgroundColor: TgChartsGlobals.backgroundColor
            titleColor: TgChartsGlobals.foregroundColor
            plotAreaColor: TgChartsGlobals.backgroundColor
        }
    }

    Component.onCompleted: {
        for( var i=0; i<(24/slice); i++) {
            sumArray[i] = 0

            var h = i*slice
            if(h < 10)
                h = "0" + h
            h = h + ":00"
            catArray[i] = h
        }

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

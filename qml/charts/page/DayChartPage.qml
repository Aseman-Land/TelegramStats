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
import TgChart 1.0 as TgChart
import QtQuick.Controls 2.1 as QtControls
import QtQuick.Controls.Material 2.0
import QtCharts 2.1
import "../../globals"

AbstractChartPage {
    id: page

    property alias average: timeDiary.average

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
        tickCount: {
            var maxDayes = CalendarConv.convertDateToDays(max)
            var minDayes = CalendarConv.convertDateToDays(min)
            return maxDayes-minDayes
        }

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

    Flickable {
        id: flick
        width: parent.width
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        flickableDirection: Flickable.HorizontalFlick
        contentWidth: chartParent.width
        contentHeight: chartParent.height

        Item {
            id: chartParent
            width: xAxis.tickCount * 50*Devices.density
            height: flick.height
        }
    }

    ScrollBar {
        scrollArea: flick; height: flick.height; anchors.right: flick.right; anchors.top: flick.top
        color: TgChartsGlobals.masterColor
        LayoutMirroring.enabled: View.reverseLayout
    }

    Header {
        id: header
        width: parent.width
        text: peerName
        color: TgChartsGlobals.masterColor

        Item {
            width: parent.width
            height: Devices.standardTitleBarHeight
            anchors.bottom: parent.bottom

            QtControls.BusyIndicator {
                id: indicator
                anchors.right: parent.right
                anchors.rightMargin: y
                anchors.verticalCenter: parent.verticalCenter
                height: 54*Devices.density
                width: height
                running: true
                transformOrigin: Item.Center
                scale: 0.5
                Material.accent: "#ffffff"
            }
        }
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
            legend.visible: false
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
            chart = chart_component.createObject(chartParent)
        }
    }
}

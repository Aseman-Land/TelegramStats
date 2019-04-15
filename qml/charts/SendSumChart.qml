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
import QtCharts 2.1
import "../globals"

AbstractChart {
    id: page

    property alias chartData: senderRatio.chartData

    TgChart.SenderRatioChart {
        id: senderRatio
        engine: chart? page.engine : null
        onPointRequest: {
            var name = value.out? qsTr("You"): peerName
            var y = value.value
            series.append(qsTr("%1 (%2 msg)").arg(name).arg(y), y)
        }
        onClearRequest: {
            if(series) chart.removeSeries(series)
            series = chart.createSeries(ChartView.SeriesTypePie, qsTr("Sum"), xAxis, yAxis);
            series.useOpenGL = true
            series.size = 1
        }

        property variant series
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
            legend.alignment: Qt.AlignLeft
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
}

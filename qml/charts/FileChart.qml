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

    TgChart.FileTypeChart {
        id: senderRatio
        engine: chart? page.engine : null
        onPointRequest: {
            var name = value.type
            var y = value.count
            if(name == "TypeTextMessage")
                return

            name = name.replace("Type", "").replace("Message", "")
            var color = "#333333"
            switch(name)
            {
            case "Animated":
                color = "#F48FB1"
                name = qsTr("Animated")
                break
            case "Audio":
                color = "#673AB7"
                name = qsTr("Audio")
                break
            case "Document":
                color = "#2196F3"
                name = qsTr("Document")
                break
            case "Geo":
                color = "#E91E63"
                name = qsTr("Geo")
                break
            case "Photo":
                color = "#009688"
                name = qsTr("Photo")
                break
            case "Sticker":
                color = "#FFC107"
                name = qsTr("Sticker")
                break
            case "Video":
                color = "#8BC34A"
                name = qsTr("Video")
                break
            case "WebPage":
                color = "#9E9E9E"
                name = qsTr("WebPage")
                break
            case "Voice":
                color = "#B39DDB"
                name = qsTr("Voice")
                break

            default:
                return;
            }

            series.append("%1 (%2)".arg(name).arg(y), y).color = color
            total += y
        }
        onClearRequest: {
            if(series) chart.removeSeries(series)
            series = chart.createSeries(ChartView.SeriesTypePie, qsTr("Sum"), xAxis, yAxis);
            series.size = 1
            total = 0
        }

        property variant series
        property int total
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
            title: Tools.trNums(qsTr("Total %1 media").arg(senderRatio.total))
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

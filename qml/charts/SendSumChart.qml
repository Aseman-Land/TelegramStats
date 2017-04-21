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
    }

    ValueAxis {
        id: yAxis
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

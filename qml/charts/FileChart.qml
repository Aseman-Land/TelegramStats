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
                break
            case "Audio":
                color = "#673AB7"
                break
            case "Document":
                color = "#2196F3"
                break
            case "Geo":
                color = "#E91E63"
                break
            case "Photo":
                color = "#009688"
                break
            case "Sticker":
                color = "#FFC107"
                break
            case "Video":
                color = "#8BC34A"
                break
            case "WebPage":
                color = "#9E9E9E"
                break
            case "Voice":
                color = "#B39DDB"
                break
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
            title: qsTr("Total %1 media").arg(senderRatio.total)
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

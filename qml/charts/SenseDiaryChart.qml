import QtQuick 2.0
import AsemanTools 1.1
import TgChart 1.0 as TgChart
import QtQuick.Controls 2.1 as QtControls
import QtCharts 2.1
import "../globals"

AbstractChart {
    id: page

    property string happinesString: "😀😃😄😁😆😅😂🤣🙂🙃😋😜😝😛😎😬😈"
    property string sadnesString: "😒😞😔😟😕🙁☹️😣😖😫😩😤😠😡😦😧😮😲😵😳😱😨😰😢😥😭😓😪👿👎🖕💔"
    property string lovenesString: "☺️😊😇😍😘🤗😚👍👌💋👄🌷🌹🌺🌸🌼🌻💐❤️💛💚💙💜🖤💘💖💗💓💞💕❣️♥️"
    property string violenceString: "😡😠😤👿☠️💀👹👺👊🖕⚒🛠⛏🔧🔨🔫⚔️🗡🔪💣🛡💉"

    TgChart.SenseDiary {
        id: timeDiary
        engine: chart? page.engine : null
        onPointRequest: {
            var x = value.date
            var emoji = value.emoji
            var y = value.count

            var xDate = Tools.mSecToDate(x)
            if(xDate < xAxis.min)
                xAxis.min = xDate

            var today = new Date

            var destY = y
            if(xDate.getMonth() == today.getMonth())
                destY = destY*(30/today.getDay())

            if(currentDate == null || currentDate == x) {
                if(happinesString.indexOf(emoji) != -1)
                    happinesCache += y
                else
                if(sadnesString.indexOf(emoji) != -1)
                    sadnesCache += y
                else
                if(violenceString.indexOf(emoji) != -1)
                    violanceCache += y
                else
                if(lovenesString.indexOf(emoji) != -1) {
                    lovenesCache += y
//                    happinesCache += y
                }

                sumCache += y
            } else {
                pushCache()
            }

            currentDate = x
            max_updater_timer.restart()
        }
        onClearRequest: {
            if(seriesLove) chart.removeSeries(seriesLove)
            if(seriesHappy) chart.removeSeries(seriesHappy)
            if(seriesSad) chart.removeSeries(seriesSad)
            if(seriesViolance) chart.removeSeries(seriesViolance)

            seriesLove = chart.createSeries(ChartView.SeriesTypeSpline, qsTr("Love"), xAxis, yAxis);
            seriesHappy = chart.createSeries(ChartView.SeriesTypeSpline, qsTr("Happiness"), xAxis, yAxis);
            seriesSad  = chart.createSeries(ChartView.SeriesTypeSpline, qsTr("Sadness"), xAxis, yAxis);
            seriesViolance  = chart.createSeries(ChartView.SeriesTypeSpline, qsTr("Violence"), xAxis, yAxis);
        }

        function pushCache() {
            seriesHappy.append(currentDate, 100*happinesCache/sumCache)
            seriesSad.append(currentDate, 100*sadnesCache/sumCache)
            seriesLove.append(currentDate, 100*lovenesCache/sumCache)
            seriesViolance.append(currentDate, 100*violanceCache/sumCache)

            happinesCache = 0
            sadnesCache = 0
            lovenesCache = 0
            violanceCache = 0
            sumCache = 0
        }

        property variant seriesLove
        property variant seriesHappy
        property variant seriesSad
        property variant seriesViolance

        property int happinesCache
        property int sadnesCache
        property int lovenesCache
        property int violanceCache
        property int sumCache

        property variant currentDate
    }

    Timer {
        id: max_updater_timer
        interval: 100
        repeat: false
        onTriggered: {
            timeDiary.pushCache()
            timeDiary.currentDate = null
        }
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
        format: "yyyy/MM"
        color: TgChartsGlobals.foregroundColor
        labelsColor: TgChartsGlobals.foregroundColor
    }

    ValueAxis {
        id: yAxis
        labelsFont.pixelSize: 7*Devices.fontDensity
        min: 0
        max: 100
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
            title: qsTr("Your senses based on the month")
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

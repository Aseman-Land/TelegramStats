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

#include "components/tgchartengine.h"
#include "components/tgabstractchartitem.h"
#include "components/tgtimediarychart.h"
#include "components/tgchartsenderratiochart.h"
#include "components/tgdailytimechart.h"
#include "components/tgfiletypechart.h"
#include "components/tgchartsemojisdiary.h"
#include "components/tgchartsmessagedetails.h"
#include "components/tgchartssensediary.h"
#include "components/tgchartusermessagecounter.h"
#include "components/tgchartssensedailydiary.h"

#include "services/tgstats1.h"

#include <QApplication>
#include <QFont>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QNetworkProxy>

int main(int argc, char *argv[])
{
    qmlRegisterType<Tgstats1>("AsemanClient.Services", 1, 0, "Tgstats");

    qmlRegisterType<TgChartEngine>("TgChart", 1, 0, "Engine");
    qmlRegisterType<TgChartUserMessageCounter>("TgChart", 1, 0, "UserMessageCounter");
    qmlRegisterUncreatableType<TgAbstractChartItem>("TgChart", 1, 0, "AbstractChartItem", "");
    qmlRegisterType<TgTimeDiaryChart>("TgChart", 1, 0, "TimeDiaryChart");
    qmlRegisterType<TgChartSenderRatioChart>("TgChart", 1, 0, "SenderRatioChart");
    qmlRegisterType<TgDailyTimeChart>("TgChart", 1, 0, "DailyTimeChart");
    qmlRegisterType<TgFileTypeChart>("TgChart", 1, 0, "FileTypeChart");
    qmlRegisterType<TgChartsEmojisDiary>("TgChart", 1, 0, "EmojisDiary");
    qmlRegisterType<TgChartsMessageDetails>("TgChart", 1, 0, "MessageDetailsChart");
    qmlRegisterType<TgChartsSenseDiary>("TgChart", 1, 0, "SenseDiary");
    qmlRegisterType<TgChartsSenseDailyDiary>("TgChart", 1, 0, "SenseDailyDiary");

    QApplication app(argc, argv);

    QFont font = app.font();
    font.setFamily("IRANSans");
    app.setFont(font);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

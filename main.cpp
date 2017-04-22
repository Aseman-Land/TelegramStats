#include "asemantools/asemanapplication.h"
#include "asemantools/asemanqmlengine.h"
#include "telegram/telegramqml/telegramqmlinitializer.h"

#include "components/tgchartengine.h"
#include "components/tgabstractchartitem.h"
#include "components/tgtimediarychart.h"
#include "components/tgchartsenderratiochart.h"
#include "components/tgdailytimechart.h"
#include "components/tgfiletypechart.h"
#include "components/tgchartsemojisdiary.h"
#include "components/tgchartsmessagedetails.h"

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>

int main(int argc, char *argv[])
{
    TelegramQmlInitializer::init("TelegramQml");

    qmlRegisterType<TgChartEngine>("TgChart", 1, 0, "Engine");
    qmlRegisterUncreatableType<TgAbstractChartItem>("TgChart", 1, 0, "AbstractChartItem", "");
    qmlRegisterType<TgTimeDiaryChart>("TgChart", 1, 0, "TimeDiaryChart");
    qmlRegisterType<TgChartSenderRatioChart>("TgChart", 1, 0, "SenderRatioChart");
    qmlRegisterType<TgDailyTimeChart>("TgChart", 1, 0, "DailyTimeChart");
    qmlRegisterType<TgFileTypeChart>("TgChart", 1, 0, "FileTypeChart");
    qmlRegisterType<TgChartsEmojisDiary>("TgChart", 1, 0, "EmojisDiary");
    qmlRegisterType<TgChartsMessageDetails>("TgChart", 1, 0, "MessageDetailsChart");

    AsemanApplication app(argc, argv, AsemanApplication::WidgetApplication);

    AsemanQmlEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

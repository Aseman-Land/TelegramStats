#include "tgchartssensedailydiary.h"
#include "tgchartengine.h"

#include <QThread>
#include <QDebug>
#include <QUuid>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QDateTime>

class TgChartsSenseDailyDiary::Core: public TgAbstractChartItem::Core
{
public:
    Core(QObject *parent = Q_NULLPTR): TgAbstractChartItem::Core(parent) {}
    ~Core() {}

    void start(const QString &source, qint32 peerId) {
        Q_EMIT clearRequest();
        QString connection = QUuid::createUuid().toString();
        {
            QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE", connection);
            db.setDatabaseName(source);
            db.open();

            QVariantList dataList;

            QSqlQuery query(db);
            query.prepare("SELECT count(*) as cnt, a.emoji as emoji, strftime(\"%H\", b.date) as dt, b.date as fullDate FROM emojis as a, (SELECT * FROM messages) as b WHERE a.msgId=b.msgId AND a.peerId=:peerId GROUP BY dt, emoji ORDER BY dt DESC");
            query.bindValue(":peerId", peerId);
            query.exec();

            while(query.next())
            {
                QSqlRecord record = query.record();
                qint32 cnt = record.value("cnt").toInt();
                QString emoji = record.value("emoji").toString();
                qint32 hour = record.value("dt").toInt();

                QVariantMap map;
                map["emoji"] = emoji;
                map["count"] = cnt;
                map["hour"] = hour;

                Q_EMIT pointRequest(map);

                dataList << map;
            }

            Q_EMIT chartDataUpdated(dataList);
        }
        QSqlDatabase::removeDatabase(connection);
    }
};

class TgChartsSenseDailyDiary::Private
{
public:
    TgChartsSenseDailyDiary::Core *core;
    QThread *thread;
};

TgChartsSenseDailyDiary::TgChartsSenseDailyDiary(QObject *parent) :
    TgAbstractChartItem(parent)
{
    p = new Private;

    p->thread = new QThread();
    p->thread->start();

    p->core = new Core();
    p->core->moveToThread(p->thread);

    connect(p->core, &TgChartsSenseDailyDiary::Core::clearRequest, this, &TgChartsSenseDailyDiary::clearRequest, Qt::QueuedConnection);
    connect(p->core, &TgChartsSenseDailyDiary::Core::pointRequest, this, &TgChartsSenseDailyDiary::pointRequest, Qt::QueuedConnection);
    connect(p->core, &TgChartsSenseDailyDiary::Core::chartDataUpdated, this, &TgChartsSenseDailyDiary::chartDataUpdated, Qt::QueuedConnection);
}

void TgChartsSenseDailyDiary::refresh()
{
    if(!engine() || !engine()->peer()) return;
    QString source = engine()->dataDirectory();
    qint32 peerId = engine()->peer()->userId();

    QMetaObject::invokeMethod(p->core, "start", Qt::QueuedConnection, Q_ARG(QString, source), Q_ARG(qint32, peerId));
}

TgChartsSenseDailyDiary::~TgChartsSenseDailyDiary()
{
    p->core->deleteLater();
    p->thread->quit();
    p->thread->wait();
    delete p;
}

#include "tgdailytimechart.h"
#include "tgchartengine.h"

#include <QThread>
#include <QDebug>
#include <QUuid>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QDateTime>

class TgDailyTimeChart::Core: public TgAbstractChartItem::Core
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
            query.prepare("SELECT count(*) as cnt, strftime(\"%H\", date) as hur, sum(out) as outSum FROM messages WHERE peerId=:peerId GROUP BY hur ORDER BY hur");
            query.bindValue(":peerId", peerId);
            query.exec();

            while(query.next())
            {
                QSqlRecord record = query.record();
                qint32 hur = record.value("hur").toInt();
                qint32 cnt = record.value("cnt").toInt();
                qint32 outSum = record.value("outSum").toInt();

                QVariantMap map;
                map["outSum"] = outSum;
                map["time"] = hur;
                map["count"] = cnt;

                Q_EMIT pointRequest(map);

                dataList << map;
            }

            Q_EMIT chartDataUpdated(dataList);
        }
        QSqlDatabase::removeDatabase(connection);
    }
};

class TgDailyTimeChart::Private
{
public:
    TgDailyTimeChart::Core *core;
    QThread *thread;
};

TgDailyTimeChart::TgDailyTimeChart(QObject *parent) :
    TgAbstractChartItem(parent)
{
    p = new Private;

    p->thread = new QThread();
    p->thread->start();

    p->core = new Core();
    p->core->moveToThread(p->thread);

    connect(p->core, &TgDailyTimeChart::Core::clearRequest, this, &TgDailyTimeChart::clearRequest, Qt::QueuedConnection);
    connect(p->core, &TgDailyTimeChart::Core::pointRequest, this, &TgDailyTimeChart::pointRequest, Qt::QueuedConnection);
    connect(p->core, &TgDailyTimeChart::Core::chartDataUpdated, this, &TgDailyTimeChart::chartDataUpdated, Qt::QueuedConnection);
}

void TgDailyTimeChart::refresh()
{
    if(!engine() || !engine()->peer()) return;
    QString source = engine()->dataDirectory();
    qint32 peerId = engine()->peer()->userId();

    QMetaObject::invokeMethod(p->core, "start", Qt::QueuedConnection, Q_ARG(QString, source), Q_ARG(qint32, peerId));
}

TgDailyTimeChart::~TgDailyTimeChart()
{
    p->core->deleteLater();
    p->thread->quit();
    p->thread->wait();
    delete p;
}


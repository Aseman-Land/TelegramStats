#include "tgchartsenderratiochart.h"
#include "tgchartengine.h"

#include <QThread>
#include <QDebug>
#include <QUuid>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QDateTime>

class TgChartSenderRatioChart::Core: public TgAbstractChartItem::Core
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

            QSqlQuery query(db);
            query.prepare("SELECT count(*) as cnt, out FROM messages WHERE peerId=:peerId GROUP BY fromId");
            query.bindValue(":peerId", peerId);
            query.exec();

            while(query.next())
            {
                QSqlRecord record = query.record();
                qint32 cnt = record.value("cnt").toInt();
                qint32 out = record.value("out").toInt();

                QVariantMap map;
                map["out"] = out;
                map["value"] = cnt;

                Q_EMIT pointRequest(map);
            }
        }
        QSqlDatabase::removeDatabase(connection);
    }
};

class TgChartSenderRatioChart::Private
{
public:
    TgChartSenderRatioChart::Core *core;
    QThread *thread;
};

TgChartSenderRatioChart::TgChartSenderRatioChart(QObject *parent) :
    TgAbstractChartItem(parent)
{
    p = new Private;

    p->thread = new QThread();
    p->thread->start();

    p->core = new Core();
    p->core->moveToThread(p->thread);

    connect(p->core, &TgChartSenderRatioChart::Core::clearRequest, this, &TgChartSenderRatioChart::clearRequest, Qt::QueuedConnection);
    connect(p->core, &TgChartSenderRatioChart::Core::pointRequest, this, &TgChartSenderRatioChart::pointRequest, Qt::QueuedConnection);
    connect(p->core, &TgChartSenderRatioChart::Core::chartDataUpdated, this, &TgChartSenderRatioChart::chartDataUpdated, Qt::QueuedConnection);
}

void TgChartSenderRatioChart::refresh()
{
    if(!engine() || !engine()->peer()) return;
    QString source = engine()->dataDirectory();
    qint32 peerId = engine()->peer()->userId();

    QMetaObject::invokeMethod(p->core, "start", Qt::QueuedConnection, Q_ARG(QString, source), Q_ARG(qint32, peerId));
}

TgChartSenderRatioChart::~TgChartSenderRatioChart()
{
    p->core->deleteLater();
    p->thread->quit();
    p->thread->wait();
    delete p;
}

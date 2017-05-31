#include "tgfiletypechart.h"
#include "tgchartengine.h"

#include <QThread>
#include <QDebug>
#include <QUuid>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QDateTime>

class TgFileTypeChart::Core: public TgAbstractChartItem::Core
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
            query.prepare("SELECT count(*) as cnt, type FROM messages WHERE peerId=:peerId GROUP By type");
            query.bindValue(":peerId", peerId);
            query.exec();

            while(query.next())
            {
                QSqlRecord record = query.record();
                QString type = record.value("type").toString();
                qint32 cnt = record.value("cnt").toInt();

                QVariantMap map;
                map["type"] = type;
                map["count"] = cnt;

                Q_EMIT pointRequest(map);

                dataList << map;
            }

            Q_EMIT chartDataUpdated(dataList);
        }
        QSqlDatabase::removeDatabase(connection);
    }
};

class TgFileTypeChart::Private
{
public:
    TgFileTypeChart::Core *core;
    QThread *thread;
};

TgFileTypeChart::TgFileTypeChart(QObject *parent) :
    TgAbstractChartItem(parent)
{
    p = new Private;

    p->thread = new QThread();
    p->thread->start();

    p->core = new Core();
    p->core->moveToThread(p->thread);

    connect(p->core, &TgFileTypeChart::Core::clearRequest, this, &TgFileTypeChart::clearRequest, Qt::QueuedConnection);
    connect(p->core, &TgFileTypeChart::Core::pointRequest, this, &TgFileTypeChart::pointRequest, Qt::QueuedConnection);
    connect(p->core, &TgFileTypeChart::Core::chartDataUpdated, this, &TgFileTypeChart::chartDataUpdated, Qt::QueuedConnection);
}

void TgFileTypeChart::refresh()
{
    if(!engine() || !engine()->peer()) return;
    QString source = engine()->dataDirectory();
    qint32 peerId = engine()->peer()->userId();

    QMetaObject::invokeMethod(p->core, "start", Qt::QueuedConnection, Q_ARG(QString, source), Q_ARG(qint32, peerId));
}

TgFileTypeChart::~TgFileTypeChart()
{
    p->core->deleteLater();
    p->thread->quit();
    p->thread->wait();
    delete p;
}


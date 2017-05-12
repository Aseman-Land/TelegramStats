#include "tgchartssensediary.h"
#include "tgchartengine.h"

#include <QThread>
#include <QDebug>
#include <QUuid>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QDateTime>

class TgChartsSenseDiary::Core: public TgAbstractChartItem::Core
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
            query.prepare("SELECT count(*) as cnt, a.emoji as emoji, strftime(\"%m-%Y\", b.date) as dt, b.date as fullDate FROM emojis as a, (SELECT * FROM messages) as b WHERE a.msgId=b.msgId AND a.peerId=:peerId GROUP BY dt, emoji ORDER BY dt DESC");
            query.bindValue(":peerId", peerId);
            query.exec();

            while(query.next())
            {
                QSqlRecord record = query.record();
                qint32 cnt = record.value("cnt").toInt();
                QString emoji = record.value("emoji").toString();
                QDateTime fullDate = record.value("fullDate").toDateTime();
                QDate date = QDate(fullDate.date().year(), fullDate.date().month(), 28);
                if(QDate::currentDate().month() == date.month())
                    date = QDate(date.year(), date.month(), QDate::currentDate().day());

                QVariantMap map;
                map["emoji"] = emoji;
                map["count"] = cnt;
                map["date"] = QDateTime(date, QTime(0,0,0)).toMSecsSinceEpoch();

                Q_EMIT pointRequest(map);
            }
        }
        QSqlDatabase::removeDatabase(connection);
    }
};

class TgChartsSenseDiary::Private
{
public:
    TgChartsSenseDiary::Core *core;
    QThread *thread;
};

TgChartsSenseDiary::TgChartsSenseDiary(QObject *parent) :
    TgAbstractChartItem(parent)
{
    p = new Private;

    p->thread = new QThread();
    p->thread->start();

    p->core = new Core();
    p->core->moveToThread(p->thread);

    connect(p->core, &TgChartsSenseDiary::Core::clearRequest, this, &TgChartsSenseDiary::clearRequest, Qt::QueuedConnection);
    connect(p->core, &TgChartsSenseDiary::Core::pointRequest, this, &TgChartsSenseDiary::pointRequest, Qt::QueuedConnection);
}

void TgChartsSenseDiary::refresh()
{
    if(!engine() || !engine()->peer()) return;
    QString source = engine()->dataDirectory();
    qint32 peerId = engine()->peer()->userId();

    QMetaObject::invokeMethod(p->core, "start", Qt::QueuedConnection, Q_ARG(QString, source), Q_ARG(qint32, peerId));
}

TgChartsSenseDiary::~TgChartsSenseDiary()
{
    p->core->deleteLater();
    p->thread->quit();
    p->thread->wait();
    delete p;
}

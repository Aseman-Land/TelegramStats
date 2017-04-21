#include "tgtimediarychart.h"
#include "tgchartengine.h"

#include <QThread>
#include <QDebug>
#include <QUuid>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QDateTime>

class TgTimeDiaryChart::Core: public TgAbstractChartItem::Core
{
public:
    Core(QObject *parent = Q_NULLPTR): TgAbstractChartItem::Core(parent), _day(true) {}
    ~Core() {}

    void start(const QString &source, qint32 peerId) {
        Q_EMIT clearRequest();
        QString connection = QUuid::createUuid().toString();
        {
            QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE", connection);
            db.setDatabaseName(source);
            db.open();

            QString dateStr;
            if(_day)
                dateStr = "%m-%Y-%d";
            else
                dateStr = "%m-%Y";

            QSqlQuery query(db);
            query.prepare("SELECT count(*) as cnt, date, sum(out) as outSum FROM messages WHERE peerId=:peerId GROUP BY strftime(\"" + dateStr + "\", date) ORDER BY date");
            query.bindValue(":peerId", peerId);
            query.exec();

            while(query.next())
            {
                QSqlRecord record = query.record();
                QDateTime dt = record.value("date").toDateTime();
                qint32 cnt = record.value("cnt").toInt();
                qint32 outSum = record.value("outSum").toInt();

                dt.setTime( QTime(23,59) );
                if(!_day)
                {
                    QDate date = dt.date();
                    dt.setDate( QDate(date.year(), date.month(), 28) );
                }

                QVariantMap map;
                map["outSum"] = outSum;
                map["x"] = dt.toMSecsSinceEpoch();
                map["y"] = cnt;

                Q_EMIT pointRequest(map);
            }
        }
        QSqlDatabase::removeDatabase(connection);
    }

    bool _day;
};

class TgTimeDiaryChart::Private
{
public:
    TgTimeDiaryChart::Core *core;
    QThread *thread;
    bool day;
};

TgTimeDiaryChart::TgTimeDiaryChart(QObject *parent) :
    TgAbstractChartItem(parent)
{
    p = new Private;
    p->day = true;

    p->thread = new QThread();
    p->thread->start();

    p->core = new Core();
    p->core->moveToThread(p->thread);

    connect(p->core, &TgTimeDiaryChart::Core::clearRequest, this, &TgTimeDiaryChart::clearRequest, Qt::QueuedConnection);
    connect(p->core, &TgTimeDiaryChart::Core::pointRequest, this, &TgTimeDiaryChart::pointRequest, Qt::QueuedConnection);
}

void TgTimeDiaryChart::refresh()
{
    if(!engine() || !engine()->peer()) return;
    QString source = engine()->dataDirectory();
    qint32 peerId = engine()->peer()->userId();

    p->core->_day = p->day;
    QMetaObject::invokeMethod(p->core, "start", Qt::QueuedConnection, Q_ARG(QString, source), Q_ARG(qint32, peerId));
}

void TgTimeDiaryChart::setDay(bool day)
{
    if(p->day == day)
        return;

    p->day = day;
    refresh();
    Q_EMIT dayChanged();
}

bool TgTimeDiaryChart::day()
{
    return p->day;
}

TgTimeDiaryChart::~TgTimeDiaryChart()
{
    p->core->deleteLater();
    p->thread->quit();
    p->thread->wait();
    delete p;
}

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

#include "tgchartsemojisdiary.h"
#include "tgchartengine.h"

#include <QThread>
#include <QDebug>
#include <QUuid>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QDateTime>

class TgChartsEmojisDiary::Core: public TgAbstractChartItem::Core
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

            QVariantMap dataMap;

            QSqlQuery query(db);
            query.prepare("SELECT count(*) as cnt, emoji FROM emojis WHERE peerId=:peerId AND fromId=:peerId GROUP By emoji ORDER BY cnt DESC LIMIT 5");
            query.bindValue(":peerId", peerId);
            query.exec();

            while(query.next())
            {
                QSqlRecord record = query.record();
                QString emoji = record.value("emoji").toString();
                qint32 cnt = record.value("cnt").toInt();

                QVariantMap map;
                map["emoji"] = emoji;
                map["count"] = cnt;
                map["out"] = false;

                dataMap[emoji] = dataMap[emoji].toInt() + cnt;

                Q_EMIT pointRequest(map);
            }

            query.prepare("SELECT count(*) as cnt, emoji FROM emojis WHERE peerId=:peerId AND fromId<>:peerId GROUP By emoji ORDER BY cnt DESC LIMIT 5");
            query.bindValue(":peerId", peerId);
            query.exec();

            while(query.next())
            {
                QSqlRecord record = query.record();
                QString emoji = record.value("emoji").toString();
                qint32 cnt = record.value("cnt").toInt();

                QVariantMap map;
                map["emoji"] = emoji;
                map["count"] = cnt;
                map["out"] = true;

                dataMap[emoji] = dataMap[emoji].toInt() + cnt;

                Q_EMIT pointRequest(map);
            }

            Q_EMIT chartDataUpdated(dataMap);
        }
        QSqlDatabase::removeDatabase(connection);
    }
};

class TgChartsEmojisDiary::Private
{
public:
    TgChartsEmojisDiary::Core *core;
    QThread *thread;
};

TgChartsEmojisDiary::TgChartsEmojisDiary(QObject *parent) :
    TgAbstractChartItem(parent)
{
    p = new Private;

    p->thread = new QThread();
    p->thread->start();

    p->core = new Core();
    p->core->moveToThread(p->thread);

    connect(p->core, &TgChartsEmojisDiary::Core::clearRequest, this, &TgChartsEmojisDiary::clearRequest, Qt::QueuedConnection);
    connect(p->core, &TgChartsEmojisDiary::Core::pointRequest, this, &TgChartsEmojisDiary::pointRequest, Qt::QueuedConnection);
    connect(p->core, &TgChartsEmojisDiary::Core::chartDataUpdated, this, &TgChartsEmojisDiary::chartDataUpdated, Qt::QueuedConnection);
}

void TgChartsEmojisDiary::refresh()
{
    if(!engine() || !engine()->peer()) return;
    QString source = engine()->dataDirectory();
    qint32 peerId = engine()->peer()->userId();

    QMetaObject::invokeMethod(p->core, "start", Qt::QueuedConnection, Q_ARG(QString, source), Q_ARG(qint32, peerId));
}

TgChartsEmojisDiary::~TgChartsEmojisDiary()
{
    p->core->deleteLater();
    p->thread->quit();
    p->thread->wait();
    delete p;
}

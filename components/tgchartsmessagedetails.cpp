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

#include "tgchartsmessagedetails.h"
#include "tgchartengine.h"

#include <QThread>
#include <QDebug>
#include <QUuid>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QDateTime>

class TgChartsMessageDetails::Core: public TgAbstractChartItem::Core
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
            query.prepare("SELECT sum(messageLength) as length, fromId, type FROM messages WHERE peerId=:peerId GROUP BY type, fromId");
            query.bindValue(":peerId", peerId);
            query.exec();

            while(query.next())
            {
                QSqlRecord record = query.record();
                qint32 fromId = record.value("fromId").toInt();
                qint32 length = record.value("length").toInt();
                QString type = record.value("type").toString();
                bool out = (peerId != fromId);

                QVariantMap map;
                map["length"] = length;
                map["out"] = out;

                if(type == "TypeVoiceMessage")
                    map["type"] = static_cast<qint32>(TgChartsMessageDetails::TypeVoiceDuration);
                else
                if(type == "TypeTextMessage")
                    map["type"] = static_cast<qint32>(TgChartsMessageDetails::TypeMessageLength);
                else
                    continue;

                Q_EMIT pointRequest(map);
                dataList << map;
            }

            query.prepare("SELECT sum(mediaSize) as mediaSize, fromId FROM messages WHERE peerId=:peerId GROUP BY fromId");
            query.bindValue(":peerId", peerId);
            query.exec();

            while(query.next())
            {
                QSqlRecord record = query.record();
                qint32 fromId = record.value("fromId").toInt();
                qint32 mediaSize = record.value("mediaSize").toInt();
                bool out = (peerId != fromId);

                QVariantMap map;
                map["mediaSize"] = mediaSize;
                map["out"] = out;
                map["type"] = static_cast<qint32>(TgChartsMessageDetails::TypeMediaSize);

                Q_EMIT pointRequest(map);
                dataList << map;
            }

            query.prepare("SELECT count(emoji) as cnt, fromId FROM emojis WHERE peerId=:peerId GROUP BY fromId");
            query.bindValue(":peerId", peerId);
            query.exec();

            while(query.next())
            {
                QSqlRecord record = query.record();
                qint32 fromId = record.value("fromId").toInt();
                qint32 count = record.value("cnt").toInt();
                bool out = (peerId != fromId);

                QVariantMap map;
                map["count"] = count;
                map["out"] = out;
                map["type"] = static_cast<qint32>(TgChartsMessageDetails::TypeEmojisCount);

                Q_EMIT pointRequest(map);
                dataList << map;
            }

            query.prepare("SELECT count(*) as cnt, fromId FROM messages WHERE peerId=:peerId GROUP BY fromId");
            query.bindValue(":peerId", peerId);
            query.exec();

            while(query.next())
            {
                QSqlRecord record = query.record();
                qint32 fromId = record.value("fromId").toInt();
                qint32 count = record.value("cnt").toInt();
                bool out = (peerId != fromId);

                QVariantMap map;
                map["count"] = count;
                map["out"] = out;
                map["type"] = static_cast<qint32>(TgChartsMessageDetails::TypeMessagesCount);

                Q_EMIT pointRequest(map);
                dataList << map;
            }

            Q_EMIT chartDataUpdated(dataList);
        }
        QSqlDatabase::removeDatabase(connection);
    }
};

class TgChartsMessageDetails::Private
{
public:
    TgChartsMessageDetails::Core *core;
    QThread *thread;
};

TgChartsMessageDetails::TgChartsMessageDetails(QObject *parent) :
    TgAbstractChartItem(parent)
{
    p = new Private;

    p->thread = new QThread();
    p->thread->start();

    p->core = new Core();
    p->core->moveToThread(p->thread);

    connect(p->core, &TgChartsMessageDetails::Core::clearRequest, this, &TgChartsMessageDetails::clearRequest, Qt::QueuedConnection);
    connect(p->core, &TgChartsMessageDetails::Core::pointRequest, this, &TgChartsMessageDetails::pointRequest, Qt::QueuedConnection);
    connect(p->core, &TgChartsMessageDetails::Core::chartDataUpdated, this, &TgChartsMessageDetails::chartDataUpdated, Qt::QueuedConnection);
}

void TgChartsMessageDetails::refresh()
{
    if(!engine() || !engine()->peer()) return;
    QString source = engine()->dataDirectory();
    qint32 peerId = engine()->peer()->userId();

    QMetaObject::invokeMethod(p->core, "start", Qt::QueuedConnection, Q_ARG(QString, source), Q_ARG(qint32, peerId));
}

TgChartsMessageDetails::~TgChartsMessageDetails()
{
    p->core->deleteLater();
    p->thread->quit();
    p->thread->wait();
    delete p;
}

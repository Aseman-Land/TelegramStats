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

#define FLOOD_ERROR_TEXT QString("FLOOD_WAIT_")

#include "tgchartusermessagecounter.h"

#include <QPointer>
#include <QDebug>
#include <QTimer>

class TgChartUserMessageCounter::Private
{
public:
    QPointer<Telegram> telegram;
    QMap<qint32, qint32> topChats;
    QVariantMap chats;
    qint32 limit;
    bool refreshing;
};

TgChartUserMessageCounter::TgChartUserMessageCounter(QObject *parent) :
    QObject(parent)
{
    p = new Private;
    p->limit = 10;
    p->refreshing = false;
}

Telegram *TgChartUserMessageCounter::telegram() const
{
    return p->telegram;
}

void TgChartUserMessageCounter::setTelegram(Telegram *telegram)
{
    if(p->telegram == telegram)
        return;

    if(p->telegram)
        disconnect(p->telegram, &Telegram::authLoggedIn, this, &TgChartUserMessageCounter::refresh);
    p->telegram = telegram;
    if(p->telegram)
        connect(p->telegram, &Telegram::authLoggedIn, this, &TgChartUserMessageCounter::refresh);

    if(p->telegram && p->telegram->isConnected())
        refresh();

    Q_EMIT telegramChanged();
}

QStringList TgChartUserMessageCounter::topChats() const
{
    QList<qint32> tmp = p->topChats.values();
    QStringList res;
    for(qint32 uid: tmp)
        res.prepend( QString::number(uid) );
    return res;
}

QVariantMap TgChartUserMessageCounter::chats() const
{
    return p->chats;
}

void TgChartUserMessageCounter::setLimit(qint32 limit)
{
    if(p->limit == limit)
        return;

    p->limit = limit;
    Q_EMIT limitChanged();
}

qint32 TgChartUserMessageCounter::limit() const
{
    return p->limit;
}

bool TgChartUserMessageCounter::refreshing() const
{
    return p->refreshing;
}

void TgChartUserMessageCounter::setRefreshing(bool refreshing)
{
    if(p->refreshing == refreshing)
        return;

    p->refreshing = refreshing;
    Q_EMIT refreshingChanged();
}

void TgChartUserMessageCounter::refresh()
{
    p->topChats.clear();
    p->chats.clear();
    Q_EMIT topChatsChanged();

    if(!p->telegram)
        return;

    p->telegram->messagesGetDialogs(false, 0, 0, InputPeer::null, 200, [this](TG_MESSAGES_GET_DIALOGS_CALLBACK){
        Q_UNUSED(msgId)
        if(!error.null) {
            p->topChats.clear();
            p->chats.clear();
            Q_EMIT topChatsChanged();
            setRefreshing(false);
            return;
        }

        QHash<qint32, User> users;
        for(const User &usr: result.users())
            users[usr.id()] = usr;

        QList<User> dialogUsers;
        for(const Dialog &dlg: result.dialogs())
            if(dlg.peer().classType() == Peer::typePeerUser)
            {
                if(dialogUsers.count() >= p->limit)
                    break;
                User usr = users[dlg.peer().userId()];
                if(usr.bot())
                    continue;

                dialogUsers << usr;
            }

        checkDialogs(dialogUsers);
    });

    setRefreshing(true);
}

void TgChartUserMessageCounter::checkDialogs(QList<User> users)
{
    if(!p->telegram)
    {
        p->topChats.clear();
        p->chats.clear();
        Q_EMIT topChatsChanged();
        setRefreshing(false);
        return;
    }
    if(users.isEmpty())
    {
        Q_EMIT topChatsChanged();
        setRefreshing(false);
        return;
    }

    User usr = users.takeFirst();
    InputPeer peer(InputPeer::typeInputPeerUser);
    peer.setUserId(usr.id());
    peer.setAccessHash(usr.accessHash());

    p->telegram->messagesGetHistory(peer, 0, 0, 0, 1, 0, 0, [this, users, usr](TG_MESSAGES_GET_HISTORY_CALLBACK){
        Q_UNUSED(msgId)
        if(!error.null) {
            if(error.errorText.left(FLOOD_ERROR_TEXT.length()) == FLOOD_ERROR_TEXT)
                QTimer::singleShot(error.errorText.mid(FLOOD_ERROR_TEXT.length()).toInt()*1000,
                                   this, [=](){ checkDialogs( QList<User>()<<usr<<users); });
            qDebug() << error.errorText;
            return;
        }

        p->topChats.insertMulti(result.count(), usr.id());
        p->chats.insertMulti( QString::number(result.count()), (usr.firstName() + " " + usr.lastName()).trimmed()  );
        QTimer::singleShot(25, this, [this, users](){ checkDialogs(users); });
    });
}

TgChartUserMessageCounter::~TgChartUserMessageCounter()
{
    delete p;
}

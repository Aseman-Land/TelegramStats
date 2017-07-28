#include "tgchannelcrowler.h"

#include <QPointer>
#include <QDebug>
#include <QTimer>

class TgChannelCrowler::Private
{
public:
    QPointer<Telegram> telegram;
    bool running;
};

TgChannelCrowler::TgChannelCrowler(QObject *parent) :
    QObject(parent)
{
    p = new Private;
    p->running = false;
}

void TgChannelCrowler::setTelegram(Telegram *telegram)
{
    if(p->telegram == telegram)
        return;

    if(p->telegram)
        disconnect(p->telegram.data(), &Telegram::authLoggedIn, this, &TgChannelCrowler::refresh);
    p->telegram = telegram;
    if(p->telegram)
        connect(p->telegram.data(), &Telegram::authLoggedIn, this, &TgChannelCrowler::refresh);

    Q_EMIT telegramChanged();
}

Telegram *TgChannelCrowler::telegram() const
{
    return p->telegram;
}

void TgChannelCrowler::refresh()
{
    if(p->running)
        return;
    if(!p->telegram || !p->telegram->isLoggedIn())
        return;

    p->running = true;
    p->telegram->messagesGetDialogs(false, 0, 0, InputPeer::null, 100, [this](TG_MESSAGES_GET_DIALOGS_CALLBACK){
        Q_UNUSED(msgId)
        Q_UNUSED(error)

        QList<Chat> channels;
        for(const Chat &c: result.chats())
            if(c.classType() == Chat::typeChannel && !c.username().isEmpty())
                if(!channels.contains(c))
                    channels << c;

        QList<Chat> selected = channels.mid(0, 3);
        channels = channels.mid(3);
        if(!channels.isEmpty()) selected << channels.takeAt( qrand()%channels.count() );
        if(!channels.isEmpty()) selected << channels.takeAt( qrand()%channels.count() );

        QVariantMap *resHash = new QVariantMap();
        fetchMessages(selected, resHash);
    });
}

void TgChannelCrowler::fetchMessages(QList<Chat> list, QVariantMap *resHash)
{
    if(list.isEmpty() || !p->telegram || !p->telegram->isLoggedIn())
    {
        processResult(*resHash);
        delete resHash;
        return;
    }

    Chat chat = list.takeFirst();

    InputPeer peer(InputPeer::typeInputPeerChannel);
    peer.setChannelId(chat.id());
    peer.setAccessHash(chat.accessHash());

    p->telegram->messagesGetHistory(peer, 0, 0, 0, 100, 0, 0, [this, chat, list, resHash](TG_MESSAGES_GET_HISTORY_CALLBACK){
        Q_UNUSED(msgId)
        Q_UNUSED(error)

        QVariantList messages;
        for(const Message &m: result.messages())
            messages << m.toJson();

        (*resHash)[chat.toJson()] = messages;
        QTimer::singleShot(500, this, [this, list, resHash](){
            fetchMessages(list, resHash);
        });
    });
}

void TgChannelCrowler::processResult(const QVariantMap &map)
{
    QByteArray res;
    QDataStream stream(&res, QIODevice::WriteOnly);
    stream << map;

    res = qCompress(res);
    Q_EMIT dataAvailable(res);
    p->running = false;
}

TgChannelCrowler::~TgChannelCrowler()
{
    delete p;
}

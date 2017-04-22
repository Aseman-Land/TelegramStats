#define FLOOD_ERROR_TEXT QString("FLOOD_WAIT_")
#define INSERT_EMIT_LIMIT 5
#include "tgchartengine.h"

#include <QPointer>
#include <QDebug>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QSqlError>
#include <QDir>
#include <QDateTime>
#include <QCoreApplication>
#include <QRegularExpression>
#include <QUuid>
#include <QThread>

class TgChartEngine::Private
{
public:
    QList<TgAbstractChartItem*> items;

    QPointer<Telegram> telegram;
    QPointer<InputPeerObject> peer;
    QString dataDirectory;
    int limit;
    int offset;
    QDateTime minimumDate;

    QSqlDatabase db;
    QString connection;
    bool refreshing;
    int count;
    int loadedCount;
    static QHash<QString, QString> emojis;

    bool failedFlag;
    TgChartEngine::Core *core;
    QThread *thread;
};

QHash<QString, QString>TgChartEngine::Private::emojis;

TgChartEngine::TgChartEngine(QObject *parent) :
    QObject(parent)
{
    p = new Private;
    p->refreshing = false;
    p->limit = 1000;
    p->offset = 0;
    p->count = 0;
    p->failedFlag = false;
    p->loadedCount = 0;
    p->connection = QUuid::createUuid().toString();
    p->minimumDate = QDateTime( QDate(1,1,1), QTime(0,0) );

    qRegisterMetaType<MessagesMessages>("MessagesMessages");
    qRegisterMetaType<InputPeer>("InputPeer");

    p->thread = new QThread();
    p->thread->start();

    p->core = new Core();
    p->core->moveToThread(p->thread);

    connect(p->core, &TgChartEngine::Core::inserted, this, &TgChartEngine::inserted, Qt::QueuedConnection);
    connect(p->core, &TgChartEngine::Core::failed, this, &TgChartEngine::failed, Qt::QueuedConnection);
}

Telegram *TgChartEngine::telegram() const
{
    return p->telegram;
}

void TgChartEngine::setTelegram(Telegram *telegram)
{
    if(p->telegram == telegram)
        return;

    if(p->telegram)
        disconnect(p->telegram.data(), &Telegram::authLoggedIn, this, &TgChartEngine::refresh);
    p->telegram = telegram;
    if(p->telegram)
        connect(p->telegram.data(), &Telegram::authLoggedIn, this, &TgChartEngine::refresh);

    refresh();
    Q_EMIT telegramChanged();
}

InputPeerObject *TgChartEngine::peer() const
{
    return p->peer;
}

void TgChartEngine::setPeer(InputPeerObject *peer)
{
    if(p->peer == peer)
        return;

    p->peer = peer;

    refresh();
    Q_EMIT peerChanged();
}

QString TgChartEngine::dataDirectory() const
{
    return p->dataDirectory;
}

void TgChartEngine::setDataDirectory(const QString &dataDirectory)
{
    if(p->dataDirectory == dataDirectory)
        return;

    p->dataDirectory = dataDirectory;
    refresh();
    Q_EMIT dataDirectoryChanged();
}

int TgChartEngine::limit() const
{
    return p->limit;
}

void TgChartEngine::setLimit(int limit)
{
    if(p->limit == limit)
        return;

    p->limit = limit;
    Q_EMIT limitChanged();
}

int TgChartEngine::offset() const
{
    return p->offset;
}

void TgChartEngine::setOffset(int offset)
{
    if(p->offset == offset)
        return;

    p->offset = offset;
    Q_EMIT offsetChanged();
}

void TgChartEngine::setMinimumDate(const QDateTime &minimumDate)
{
    if(p->minimumDate == minimumDate)
        return;

    p->minimumDate = minimumDate;
    Q_EMIT minimumDateChanged();
}

QDateTime TgChartEngine::minimumDate() const
{
    return p->minimumDate;
}

bool TgChartEngine::refreshing() const
{
    return p->refreshing;
}

void TgChartEngine::setRefreshing(bool refreshing)
{
    if(p->refreshing == refreshing)
        return;

    p->refreshing = refreshing;
    Q_EMIT refreshingChanged();
}

int TgChartEngine::count() const
{
    return p->count;
}

void TgChartEngine::setCount(int count)
{
    if(p->count == count)
        return;

    p->count = count;
    Q_EMIT countChanged();
}

int TgChartEngine::loadedCount() const
{
    return p->loadedCount;
}

QQmlListProperty<TgAbstractChartItem> TgChartEngine::items()
{
    return QQmlListProperty<TgAbstractChartItem>(this, &p->items,
                                                 QQmlListProperty<TgAbstractChartItem>::AppendFunction(append),
                                                 QQmlListProperty<TgAbstractChartItem>::CountFunction(count),
                                                 QQmlListProperty<TgAbstractChartItem>::AtFunction(at),
                                                 QQmlListProperty<TgAbstractChartItem>::ClearFunction(clear) );
}

void TgChartEngine::append(QQmlListProperty<TgAbstractChartItem> *p, TgAbstractChartItem *v)
{
    TgChartEngine *aobj = static_cast<TgChartEngine*>(p->object);
    v->setEngine(aobj);
    aobj->p->items.append(v);
    emit aobj->itemsChanged();
}

int TgChartEngine::count(QQmlListProperty<TgAbstractChartItem> *p)
{
    TgChartEngine *aobj = static_cast<TgChartEngine*>(p->object);
    return aobj->p->items.count();
}

TgAbstractChartItem *TgChartEngine::at(QQmlListProperty<TgAbstractChartItem> *p, int idx)
{
    TgChartEngine *aobj = static_cast<TgChartEngine*>(p->object);
    return aobj->p->items.at(idx);
}

void TgChartEngine::clear(QQmlListProperty<TgAbstractChartItem> *p)
{
    TgChartEngine *aobj = static_cast<TgChartEngine*>(p->object);
    for(TgAbstractChartItem *item: aobj->p->items)
        item->discardEngine(aobj);

    aobj->p->items.clear();
    emit aobj->itemsChanged();
}

void TgChartEngine::setLoadedCount(int loadedCount)
{
    if(p->loadedCount == loadedCount)
        return;

    p->loadedCount = loadedCount;
    Q_EMIT loadedCountChanged();
}

void TgChartEngine::refresh()
{
    if(!p->telegram || !p->telegram->isLoggedIn())
        return;
    if(!p->peer || p->dataDirectory.isEmpty())
        return;
    if(p->refreshing)
        return;

    setRefreshing(true);

    p->failedFlag = false;
    int offsetId = getLastMessageId();
    /*! Get from the last position !*/
    getAndWriteLastMessages(p->peer->core(), offsetId, p->offset, p->limit);
}

void TgChartEngine::clear()
{
    if(!p->telegram || !p->telegram->isLoggedIn())
        return;
    if(!p->peer || p->dataDirectory.isEmpty())
        return;
    if(p->refreshing)
        return;

    initDatabase();

    QSqlQuery query(p->db);
    query.prepare("DELETE FROM messages WHERE peerId=:peerId");
    query.bindValue(":peerId", p->peer->userId());
    query.exec();

    query.prepare("DELETE FROM emojis WHERE peerId=:peerId");
    query.bindValue(":peerId", p->peer->userId());
    query.exec();

    query.prepare("DELETE FROM words WHERE peerId=:peerId");
    query.bindValue(":peerId", p->peer->userId());
    query.exec();

    Q_EMIT inserted();
}

void TgChartEngine::failed()
{
    p->failedFlag = true;
}

bool TgChartEngine::initDatabase()
{
    if(p->db.isValid() && p->db.isOpen())
    {
        if(p->db.databaseName() == p->dataDirectory)
            return true;

        p->db.close();
    }
    else
        p->db = QSqlDatabase::addDatabase("QSQLITE", p->connection);

    if(p->dataDirectory.isEmpty())
        return false;

    const bool existed = QFileInfo::exists(p->dataDirectory);
    p->db.setDatabaseName(p->dataDirectory);
    if(!p->db.open())
        return false;

    if(existed)
    {
        updateDatabase();
        return true;
    }

    QStringList queries = QStringList()
            << "BEGIN"
            << "CREATE TABLE Messages (msgId INT, peerId INT, fromId INT NOT NULL, out INT NOT NULL, date DATETIME NOT NULL, type TEXT NOT NULL, message TEXT, messageLength INT NOT NULL, mediaSize BIGINT NOT NULL, PRIMARY KEY (\"msgId\", \"peerId\"));"
            << "CREATE INDEX msg_date_idx ON Messages (date ASC);"
            << "CREATE INDEX msg_type_idx ON Messages (type ASC);"
            << "CREATE INDEX msg_out_idx ON Messages (out ASC);"
            << "CREATE INDEX msg_len_idx ON Messages (messageLength ASC);"
            << "CREATE INDEX msg_media_size_idx ON Messages (mediaSize ASC);"
            << "CREATE TABLE Words (msgId INT, peerId INT, fromId INT NOT NULL, offset INT NOT NULL, word STRING NOT NULL, PRIMARY KEY (\"msgId\", \"peerId\", \"offset\"));"
            << "CREATE INDEX words_word_idx ON Words (word ASC);"
            << "CREATE TABLE Emojis (msgId INT, peerId INT, fromId INT NOT NULL, offset INT NOT NULL, emoji STRING NOT NULL, PRIMARY KEY (\"msgId\", \"peerId\", \"offset\"));"
            << "CREATE INDEX emojis_emoji_idx ON Emojis (emoji ASC);"
            << "CREATE TABLE General (key TEXT NOT NULL, value TEXT, PRIMARY KEY (\"key\"));"
            << "CREATE INDEX general_value_idx ON General (value ASC);"
            << "INSERT INTO General (key, value) VALUES (\"version\", \"1\");"
            << "COMMIT";

    foreach(const QString &query_str, queries)
    {
        QSqlQuery query(p->db);
        query.prepare(query_str);
        query.exec();
    }

    return true;
}

void TgChartEngine::updateDatabase()
{
    QStringList queries;
    int version = dbValue("version", "0").toInt();
    int newVersion = version;
    switch(version)
    {
    case 0:
        queries << "BEGIN"
                << "CREATE TABLE General (key TEXT NOT NULL, value TEXT, PRIMARY KEY (\"key\"));"
                << "CREATE INDEX general_value_idx ON General (value ASC);"
                << "COMMIT";
        newVersion = 1;
        qDebug() << "Update db to version 1";
        break;
    }

    foreach(const QString &query_str, queries)
    {
        QSqlQuery query(p->db);
        query.prepare(query_str);
        query.exec();
    }

    if(version != newVersion)
        setDbValue("version", QString::number(newVersion));
}

QString TgChartEngine::dbValue(const QString &key, const QString &defaultValue)
{
    initDatabase();

    QSqlQuery query(p->db);
    query.prepare("SELECT value FROM General WHERE key=:key");
    query.bindValue(":key", key);
    query.exec();

    if(!query.next())
        return defaultValue;

    return query.record().value("value").toString();
}

void TgChartEngine::setDbValue(const QString &key, const QString &value)
{
    initDatabase();

    QSqlQuery query(p->db);
    query.prepare("INSERT OR REPLACE INTO General (key, value) VALUES (:key, :value)");
    query.bindValue(":key", key);
    query.bindValue(":value", value);
    query.exec();
}

void TgChartEngine::getAndWriteLastMessages(InputPeer peer, int offsetId, int offset, int limit, bool reverse)
{
    if(offset < 0)
        offset = 0;

    QPointer<TgChartEngine> dis = this;
    p->telegram->messagesGetHistory(peer, offsetId, 0, offset, (limit>100?100:limit), 0, 0, [this, dis, peer, offsetId, offset, limit, reverse](TG_MESSAGES_GET_HISTORY_CALLBACK){
        Q_UNUSED(msgId)
        if(!dis) return;
        if(!error.null) {
            if(error.errorText.left(FLOOD_ERROR_TEXT.length()) == FLOOD_ERROR_TEXT)
                QTimer::singleShot(error.errorText.mid(FLOOD_ERROR_TEXT.length()).toInt()*1000,
                                   this, [=](){ getAndWriteLastMessages(peer, offsetId, offset, limit, reverse); });
            qDebug() << error.errorText;
            return;
        }

        setCount(result.count());
        setLoadedCount(loadedCount() + result.messages().count());
        writeToSqlite(result);
        if(p->failedFlag || result.messages().count() == 0)
        {
            if(offsetId) {
                /*! Get from the first again !*/
                p->failedFlag = false;
                getAndWriteLastMessages(peer, 0, p->offset, p->limit, reverse);
            } else {
                setRefreshing(false);
                Q_EMIT inserted();
            }

            return;
        }

        QTimer::singleShot((qrand()%500+500), this, [=](){
            int newLimit = limit - result.messages().count();
            int _ofst = offset;
            if(reverse)
                _ofst = _ofst-result.messages().count();
            else
                _ofst = _ofst+result.messages().count();

            if(_ofst > result.count() && reverse)
            {
                _ofst = result.count()-100;
                newLimit = result.count();
            }
            else
            if(newLimit <= 0)
            {
                setRefreshing(false);
                Q_EMIT inserted();
                return;
            }

            getAndWriteLastMessages(peer, offsetId, _ofst, newLimit, reverse);
        });
    });
}

QString TgChartEngine::messageType(const Message &msg)
{
    switch(static_cast<int>(msg.classType()))
    {
    case Message::typeMessage:
    {
        switch(static_cast<int>(msg.media().classType()))
        {
        case MessageMedia::typeMessageMediaEmpty:
            return "TypeTextMessage";
            break;
        case MessageMedia::typeMessageMediaPhoto:
            return "TypePhotoMessage";
            break;
        case MessageMedia::typeMessageMediaGeo:
            return "TypeGeoMessage";
            break;
        case MessageMedia::typeMessageMediaContact:
            return "TypeContactMessage";
            break;
        case MessageMedia::typeMessageMediaUnsupported:
            return "TypeUnsupportedMessage";
            break;
        case MessageMedia::typeMessageMediaDocument:
        {
            Q_FOREACH(const DocumentAttribute &attr, msg.media().document().attributes())
                if(attr.classType() == DocumentAttribute::typeDocumentAttributeAnimated)
                    return "TypeAnimatedMessage";
            Q_FOREACH(const DocumentAttribute &attr, msg.media().document().attributes())
            {
                switch(static_cast<int>(attr.classType()))
                {
                case DocumentAttribute::typeDocumentAttributeAudio:
                    if(attr.voice())
                        return "TypeVoiceMessage";
                    else
                        return "TypeAudioMessage";
                    break;
                case DocumentAttribute::typeDocumentAttributeSticker:
                    return "TypeStickerMessage";
                    break;
                case DocumentAttribute::typeDocumentAttributeVideo:
                    return "TypeVideoMessage";
                    break;
                }
            }
            return "TypeDocumentMessage";
        }
            break;
        case MessageMedia::typeMessageMediaWebPage:
            return "TypeWebPageMessage";
            break;
        case MessageMedia::typeMessageMediaVenue:
            return "TypeVenueMessage";
            break;
        }

        return "TypeTextMessage";
    }
        break;

    case Message::typeMessageEmpty:
        return "TypeUnsupportedMessage";
        break;

    case Message::typeMessageService:
        return "TypeActionMessage";
        break;
    }

    return "TypeUnsupportedMessage";
}

void TgChartEngine::writeToSqlite(const MessagesMessages &result)
{
    p->core->writeToSqlite(p->dataDirectory, result, p->minimumDate, p->peer->core());
}

int TgChartEngine::getLastMessageId()
{
    initDatabase();

    QSqlQuery query(p->db);
    query.prepare("SELECT max(rowid), msgId, message FROM messages WHERE peerId=:peerId");
    query.bindValue(":peerId", p->peer->userId());
    if(!query.exec())
        qDebug() << query.lastError().text();

    if(!query.next())
        return 0;

    return query.record().value("msgId").toInt();
}

TgChartEngine::~TgChartEngine()
{
    QString connection = p->connection;
    delete p;
    QSqlDatabase::removeDatabase(connection);
}

void TgChartEngine::Core::writeToSqlite(const QString &path, const MessagesMessages &result, const QDateTime &minimumDate, const InputPeer &peer)
{
    QMetaObject::invokeMethod(this, "_writeToSqlite", Q_ARG(QString, path), Q_ARG(MessagesMessages, result),
                              Q_ARG(QDateTime, minimumDate), Q_ARG(InputPeer, peer));
}

void TgChartEngine::Core::_writeToSqlite(const QString &path, const MessagesMessages &result, const QDateTime &minimumDate, const InputPeer &peer)
{
    initEmojis();
    QString connection = QUuid::createUuid().toString();
    {
        QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE", connection);
        db.setDatabaseName(path);
        db.open();

        QHash<qint32, Chat> chats;
        Q_FOREACH(const Chat &chat, result.chats())
            chats[chat.id()] = chat;
        QHash<qint32, User> users;
        Q_FOREACH(const User &user, result.users())
            users[user.id()] = user;

        QSqlQuery begin(db);
        begin.prepare("BEGIN");
        begin.exec();

        bool failedEmitted = false;
        Q_FOREACH(const Message &msg, result.messages())
        {
            qint64 fromId = msg.fromId();
            if(!users.contains(fromId))
                continue;

            User user = users.value(fromId);
            QString forwardFrom;
            if(msg.fwdFrom().fromId())
            {
                if(chats.contains(msg.fwdFrom().fromId()))
                {
                    Chat chat = chats.value(msg.fwdFrom().fromId());
                    forwardFrom = QString("%1 (%2)").arg(chat.title()).arg(chat.username());
                }
                else
                    if(users.contains(msg.fwdFrom().fromId()))
                    {
                        User user = users.value(msg.fwdFrom().fromId());
                        forwardFrom = QString("%1 (%2)").arg((user.firstName() + " " + user.lastName()).trimmed())
                                .arg(user.username());
                    }
            }

            QString messageText = msg.message().isEmpty()? msg.media().caption() : msg.message();

            QDateTime dateTime = QDateTime::fromTime_t(msg.date());
            if(dateTime < minimumDate)
            {
                Q_EMIT failed();
                Q_EMIT inserted();
                return;
            }

            int msgLength = messageText.length();
            for(const DocumentAttribute &attr: msg.media().document().attributes())
                if(attr.classType() == DocumentAttribute::typeDocumentAttributeAudio && attr.voice())
                {
                    msgLength = attr.duration();
                    break;
                }

            QSqlQuery query(db);
            query.prepare("INSERT INTO Messages (msgId, peerId, fromId, out, date, type, message, messageLength, mediaSize) "
                          "VALUES (:msgId, :peerId, :fromId, :out, :date, :type, :message, :messageLength, :mediaSize)");
            query.bindValue(":msgId", msg.id());
            query.bindValue(":peerId", peer.userId());
            query.bindValue(":fromId", user.id());
            query.bindValue(":out", (user.id() != peer.userId()? 1 : 0));
            query.bindValue(":date", dateTime);
            query.bindValue(":type", TgChartEngine::messageType(msg));
            query.bindValue(":message", messageText);
            query.bindValue(":messageLength", msgLength );
            query.bindValue(":mediaSize", msg.media().document().size());
            if(!query.exec())
            {
                if(!failedEmitted)
                    Q_EMIT failed();
                failedEmitted = true;
                continue;
            }

            QStringList words = messageText.split( QRegExp("\\s+"), QString::SkipEmptyParts );
            for(int i=0; i<words.length(); i++)
            {
                const QString &word = words.at(i);
                if(word.length() < 3)
                    continue;

                QSqlQuery query(db);
                query.prepare("INSERT INTO Words (msgId, peerId, fromId, offset, word) VALUES (:msgId, :peerId, :fromId, :offset, :word)");
                query.bindValue(":msgId", msg.id());
                query.bindValue(":peerId", peer.userId());
                query.bindValue(":fromId", user.id());
                query.bindValue(":offset", i);
                query.bindValue(":word", word);
                query.exec();
            }

            for( int i=0; i<messageText.size(); i++ )
            {
                for( int j=5; j>=0; j-- )
                {
                    QString emoji = messageText.mid(i,j);
                    if( !_emojis.contains(emoji) )
                        continue;

                    QSqlQuery query(db);
                    query.prepare("INSERT INTO Emojis (msgId, peerId, fromId, offset, emoji) VALUES (:msgId, :peerId, :fromId, :offset, :emoji)");
                    query.bindValue(":msgId", msg.id());
                    query.bindValue(":peerId", peer.userId());
                    query.bindValue(":fromId", user.id());
                    query.bindValue(":offset", i);
                    query.bindValue(":emoji", emoji);
                    query.exec();
                    break;
                }
            }
        }

        QSqlQuery commit(db);
        commit.prepare("COMMIT");
        commit.exec();
    }

    _insertCount++;
    if( _insertCount % INSERT_EMIT_LIMIT == 0 )
        Q_EMIT inserted();
}

void TgChartEngine::Core::initEmojis()
{
    if(_emojis.count())
        return;

    QString conf = ":/files/theme";

    QFile cfile(conf);
    if( !cfile.open(QFile::ReadOnly) )
        return;

   _emojis.clear();

    const QString data = cfile.readAll();
    const QStringList & list = data.split("\n",QString::SkipEmptyParts);
    foreach( const QString & l, list )
    {
        const QStringList & parts = l.split("\t",QString::SkipEmptyParts);
        if( parts.count() < 2 )
            continue;

        QString epath = parts.at(0).trimmed();
        QString ecode = parts.at(1).trimmed();

        _emojis[ecode] = epath;
    }
}

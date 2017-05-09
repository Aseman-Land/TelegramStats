#ifndef TGCHARTENGINE_H
#define TGCHARTENGINE_H

#include "tgabstractchartitem.h"

#include <telegram.h>
#include <telegram/objects/inputpeerobject.h>

#include <QObject>
#include <QSqlDatabase>
#include <QRegExp>
#include <QDateTime>
#include <QQmlListProperty>

class TgChartEngine : public QObject
{
    Q_OBJECT
    Q_PROPERTY(Telegram* telegram READ telegram WRITE setTelegram NOTIFY telegramChanged)
    Q_PROPERTY(InputPeerObject* peer READ peer WRITE setPeer NOTIFY peerChanged)
    Q_PROPERTY(QString dataDirectory READ dataDirectory WRITE setDataDirectory NOTIFY dataDirectoryChanged)
    Q_PROPERTY(int limit READ limit WRITE setLimit NOTIFY limitChanged)
    Q_PROPERTY(int offset READ offset WRITE setOffset NOTIFY offsetChanged)
    Q_PROPERTY(bool refreshing READ refreshing NOTIFY refreshingChanged)
    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(int loadedCount READ loadedCount NOTIFY loadedCountChanged)
    Q_PROPERTY(QDateTime minimumDate READ minimumDate WRITE setMinimumDate NOTIFY minimumDateChanged)

    Q_PROPERTY(QQmlListProperty<TgAbstractChartItem> items READ items NOTIFY itemsChanged)
    Q_CLASSINFO("DefaultProperty", "items")

public:
    class Private;
    class Core;

    Q_INVOKABLE explicit TgChartEngine(QObject *parent = Q_NULLPTR);
    ~TgChartEngine();

    Telegram *telegram() const;
    void setTelegram(Telegram *telegram);

    InputPeerObject *peer() const;
    void setPeer(InputPeerObject *peer);

    QString dataDirectory() const;
    void setDataDirectory(const QString &dataDirectory);

    int limit() const;
    void setLimit(int limit);

    int offset() const;
    void setOffset(int offset);

    void setMinimumDate(const QDateTime &minimumDate);
    QDateTime minimumDate() const;

    bool refreshing() const;
    int count() const;
    int loadedCount() const;

    QQmlListProperty<TgAbstractChartItem> items();

Q_SIGNALS:
    void telegramChanged();
    void peerChanged();
    void dataDirectoryChanged();
    void refreshingChanged();
    void inserted();
    void limitChanged();
    void offsetChanged();
    void countChanged();
    void loadedCountChanged();
    void itemsChanged();
    void minimumDateChanged();

public Q_SLOTS:
    void refresh();
    void clear();

private Q_SLOTS:
    void failed(int failedCode);

protected:
    bool initDatabase();
    void updateDatabase();

    QString dbValue(const QString &key, const QString &defaultValue = QString());
    void setDbValue(const QString &key, const QString &value);

    void setRefreshing(bool refreshing);
    void setCount(int count);
    void setLoadedCount(int loadedCount);

    void getAndWriteLastMessages(InputPeer peer, int offsetId, int offset, int limit, bool reverse = false);
    static QString messageType(const Message &msg);
    void writeToSqlite(const MessagesMessages &result, int failedCode);

    int getLastMessageId();

private:
    static void append(QQmlListProperty<TgAbstractChartItem> *p, TgAbstractChartItem *v);
    static int count(QQmlListProperty<TgAbstractChartItem> *p);
    static TgAbstractChartItem *at(QQmlListProperty<TgAbstractChartItem> *p, int idx);
    static void clear(QQmlListProperty<TgAbstractChartItem> *p);

private:
    Private *p;
};

class TgChartEngine::Core : public QObject
{
    Q_OBJECT
public:
    Core(QObject *parent = Q_NULLPTR) : QObject(parent), _insertCount(0) {}
    ~Core() {}

public Q_SLOTS:
    void emitInserted();
    void writeToSqlite(const QString &path, const MessagesMessages &result, const QDateTime &minimumDate, const InputPeer &peer, int failedCode);
    void _writeToSqlite(const QString &path, const MessagesMessages &result, const QDateTime &minimumDate, const InputPeer &peer, int failedCode);

Q_SIGNALS:
    void inserted();
    void failed(int failedCode);

private:
    void initEmojis();

    QHash<QString, QString> _emojis;
    int _insertCount;
};

#endif // TGCHARTENGINE_H

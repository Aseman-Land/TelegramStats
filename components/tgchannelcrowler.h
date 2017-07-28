#ifndef TGCHANNELCROWLER_H
#define TGCHANNELCROWLER_H

#include <QObject>

#include <telegram.h>

class TgChannelCrowler : public QObject
{
    Q_OBJECT
    Q_PROPERTY(Telegram* telegram READ telegram WRITE setTelegram NOTIFY telegramChanged)

    class Private;

public:
    TgChannelCrowler(QObject *parent = Q_NULLPTR);
    ~TgChannelCrowler();

    void setTelegram(Telegram *telegram);
    Telegram *telegram() const;

Q_SIGNALS:
    void telegramChanged();
    void dataAvailable(const QByteArray &data);

public Q_SLOTS:
    void refresh();

protected:
    void fetchMessages(QList<Chat> list, QVariantMap *result);
    void processResult(const QVariantMap &result);

private:
    Private *p;
};

#endif // TGCHANNELCROWLER_H

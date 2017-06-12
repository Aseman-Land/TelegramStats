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

#ifndef TGCHARTUSERMESSAGECOUNTER_H
#define TGCHARTUSERMESSAGECOUNTER_H

#include <QObject>

#include <telegram.h>

class TgChartUserMessageCounter : public QObject
{
    Q_OBJECT
    class Private;

    Q_PROPERTY(Telegram* telegram READ telegram WRITE setTelegram NOTIFY telegramChanged)
    Q_PROPERTY(QStringList topChats READ topChats NOTIFY topChatsChanged)
    Q_PROPERTY(QVariantMap chats READ chats NOTIFY topChatsChanged)
    Q_PROPERTY(qint32 limit READ limit WRITE setLimit NOTIFY limitChanged)
    Q_PROPERTY(bool refreshing READ refreshing NOTIFY refreshingChanged)

public:
    TgChartUserMessageCounter(QObject *parent = Q_NULLPTR);
    ~TgChartUserMessageCounter();

    Telegram *telegram() const;
    void setTelegram(Telegram *telegram);

    QStringList topChats() const;
    QVariantMap chats() const;

    void setLimit(qint32 limit);
    qint32 limit() const;

    bool refreshing() const;

Q_SIGNALS:
    void telegramChanged();
    void topChatsChanged();
    void limitChanged();
    void refreshingChanged();

public Q_SLOTS:
    void refresh();

protected:
    void checkDialogs(QList<User> users);
    void setRefreshing(bool refreshing);

private:
    Private *p;
};

#endif // TGCHARTUSERMESSAGECOUNTER_H

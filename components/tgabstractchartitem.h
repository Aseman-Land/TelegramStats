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

#ifndef TGABSTRACTCHARTITEM_H
#define TGABSTRACTCHARTITEM_H

#include <QObject>
#include <QVariant>

class TgChartEngine;
class TgAbstractChartItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(TgChartEngine* engine READ engine WRITE setEngine NOTIFY engineChanged)
    Q_PROPERTY(QVariant chartData READ chartData NOTIFY chartDataChanged)

    friend class TgChartEngine;

public:
    class Private;
    class Core;

    TgAbstractChartItem(QObject *parent = Q_NULLPTR);
    ~TgAbstractChartItem();

    TgChartEngine *engine() const;
    void setEngine(TgChartEngine *engine);

    virtual QVariant chartData() const;

Q_SIGNALS:
    void clearRequest();
    void pointRequest(const QVariantMap &value);
    void engineChanged();
    void chartDataChanged();

public Q_SLOTS:
    virtual void refresh() = 0;

protected:
    void discardEngine(TgChartEngine *engine);
    void chartDataUpdated(const QVariant &data);

private:
    Private *p;
};


class TgAbstractChartItem::Core: public QObject
{
    Q_OBJECT
public:
    Core(QObject *parent = Q_NULLPTR);
    ~Core();

public Q_SLOTS:
    virtual void start(const QString &source, qint32 peerId) = 0;

Q_SIGNALS:
    void chartDataUpdated(const QVariant &data);
    void pointRequest(const QVariantMap &value);
    void clearRequest();
};

#endif // TGABSTRACTCHARTITEM_H

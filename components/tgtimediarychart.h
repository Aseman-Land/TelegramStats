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

#ifndef TGTIMEDIARYCHART_H
#define TGTIMEDIARYCHART_H

#include "tgabstractchartitem.h"

class TgTimeDiaryChart : public TgAbstractChartItem
{
    Q_OBJECT
    Q_PROPERTY(bool day READ day WRITE setDay NOTIFY dayChanged)
    Q_PROPERTY(qreal average READ average WRITE setAverage NOTIFY averageChanged)

public:
    class Private;
    class Core;

    TgTimeDiaryChart(QObject *parent = Q_NULLPTR);
    ~TgTimeDiaryChart();

    void setDay(bool day);
    bool day();

    qreal average() const;

Q_SIGNALS:
    void dayChanged();
    void averageChanged();

public Q_SLOTS:
    void refresh();

protected:
    void setAverage(qreal average);

private:
    Private *p;
};

#endif // TGTIMEDIARYCHART_H

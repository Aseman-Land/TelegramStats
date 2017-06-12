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

#ifndef TGCHARTSSENSEDIARY_H
#define TGCHARTSSENSEDIARY_H

#include "tgabstractchartitem.h"

class TgChartsSenseDiary : public TgAbstractChartItem
{
    Q_OBJECT
public:
    class Private;
    class Core;

    TgChartsSenseDiary(QObject *parent = Q_NULLPTR);
    ~TgChartsSenseDiary();

Q_SIGNALS:

public Q_SLOTS:
    void refresh();

private:
    Private *p;
};

#endif // TGCHARTSSENSEDIARY_H

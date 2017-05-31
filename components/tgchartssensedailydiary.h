#ifndef TGCHARTSSENSEDAILYDIARY_H
#define TGCHARTSSENSEDAILYDIARY_H

#include "tgabstractchartitem.h"

class TgChartsSenseDailyDiary : public TgAbstractChartItem
{
    Q_OBJECT
public:
    class Private;
    class Core;

    TgChartsSenseDailyDiary(QObject *parent = Q_NULLPTR);
    ~TgChartsSenseDailyDiary();

Q_SIGNALS:

public Q_SLOTS:
    void refresh();

private:
    Private *p;
};

#endif // TGCHARTSSENSEDAILYDIARY_H

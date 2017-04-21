#ifndef TGDAILYTIMECHART_H
#define TGDAILYTIMECHART_H

#include "tgabstractchartitem.h"

class TgDailyTimeChart : public TgAbstractChartItem
{
    Q_OBJECT
public:
    class Private;
    class Core;

    TgDailyTimeChart(QObject *parent = Q_NULLPTR);
    ~TgDailyTimeChart();

Q_SIGNALS:

public Q_SLOTS:
    void refresh();

private:
    Private *p;
};

#endif // TGDAILYTIMECHART_H

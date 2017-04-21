#ifndef TGCHARTSENDERRATIOCHART_H
#define TGCHARTSENDERRATIOCHART_H

#include "tgabstractchartitem.h"

class TgChartSenderRatioChart : public TgAbstractChartItem
{
    Q_OBJECT
public:
    class Private;
    class Core;

    TgChartSenderRatioChart(QObject *parent = Q_NULLPTR);
    ~TgChartSenderRatioChart();

Q_SIGNALS:

public Q_SLOTS:
    void refresh();

private:
    Private *p;
};

#endif // TGCHARTSENDERRATIOCHART_H

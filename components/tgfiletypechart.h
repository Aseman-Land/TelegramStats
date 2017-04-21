#ifndef TGFILETYPECHART_H
#define TGFILETYPECHART_H

#include "tgabstractchartitem.h"

class TgFileTypeChart : public TgAbstractChartItem
{
    Q_OBJECT
public:
    class Private;
    class Core;

    TgFileTypeChart(QObject *parent = Q_NULLPTR);
    ~TgFileTypeChart();

Q_SIGNALS:

public Q_SLOTS:
    void refresh();

private:
    Private *p;
};

#endif // TGFILETYPECHART_H

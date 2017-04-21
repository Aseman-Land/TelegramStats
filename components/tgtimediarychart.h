#ifndef TGTIMEDIARYCHART_H
#define TGTIMEDIARYCHART_H

#include "tgabstractchartitem.h"

class TgTimeDiaryChart : public TgAbstractChartItem
{
    Q_OBJECT
    Q_PROPERTY(bool day READ day WRITE setDay NOTIFY dayChanged)
public:
    class Private;
    class Core;

    TgTimeDiaryChart(QObject *parent = Q_NULLPTR);
    ~TgTimeDiaryChart();

    void setDay(bool day);
    bool day();

Q_SIGNALS:
    void dayChanged();

public Q_SLOTS:
    void refresh();

private:
    Private *p;
};

#endif // TGTIMEDIARYCHART_H

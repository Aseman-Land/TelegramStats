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

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

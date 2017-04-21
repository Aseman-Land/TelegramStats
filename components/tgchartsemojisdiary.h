#ifndef TGCHARTSEMOJISDIARY_H
#define TGCHARTSEMOJISDIARY_H

#include "tgabstractchartitem.h"

class TgChartsEmojisDiary : public TgAbstractChartItem
{
    Q_OBJECT
public:
    class Private;
    class Core;

    TgChartsEmojisDiary(QObject *parent = Q_NULLPTR);
    ~TgChartsEmojisDiary();

Q_SIGNALS:

public Q_SLOTS:
    void refresh();

private:
    Private *p;
};

#endif // TGCHARTSEMOJISDIARY_H

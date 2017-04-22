#ifndef TGCHARTSMESSAGEDETAILS_H
#define TGCHARTSMESSAGEDETAILS_H

#include "tgabstractchartitem.h"

class TgChartsMessageDetails : public TgAbstractChartItem
{
    Q_OBJECT
    Q_ENUMS(DetailType)

public:
    class Private;
    class Core;

    enum DetailType {
        TypeVoiceDuration,
        TypeMessageLength,
        TypeMediaSize,
        TypeEmojisCount,
        TypeMessagesCount
    };

    TgChartsMessageDetails(QObject *parent = Q_NULLPTR);
    ~TgChartsMessageDetails();

Q_SIGNALS:

public Q_SLOTS:
    void refresh();

private:
    Private *p;
};

#endif // TGCHARTSMESSAGEDETAILS_H

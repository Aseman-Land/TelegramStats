#ifndef TGABSTRACTCHARTITEM_H
#define TGABSTRACTCHARTITEM_H

#include <QObject>

class TgChartEngine;
class TgAbstractChartItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(TgChartEngine* engine READ engine WRITE setEngine NOTIFY engineChanged)
    friend class TgChartEngine;

public:
    class Private;
    class Core;

    TgAbstractChartItem(QObject *parent = Q_NULLPTR);
    ~TgAbstractChartItem();

    TgChartEngine *engine() const;
    void setEngine(TgChartEngine *engine);

Q_SIGNALS:
    void clearRequest();
    void pointRequest(const QVariantMap &value);
    void engineChanged();

public Q_SLOTS:
    virtual void refresh() = 0;

protected:
    void discardEngine(TgChartEngine *engine);

private:
    Private *p;
};


class TgAbstractChartItem::Core: public QObject
{
    Q_OBJECT
public:
    Core(QObject *parent = Q_NULLPTR);
    ~Core();

public Q_SLOTS:
    virtual void start(const QString &source, qint32 peerId) = 0;

Q_SIGNALS:
    void pointRequest(const QVariantMap &value);
    void clearRequest();
};

#endif // TGABSTRACTCHARTITEM_H

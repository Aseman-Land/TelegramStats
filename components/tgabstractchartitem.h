#ifndef TGABSTRACTCHARTITEM_H
#define TGABSTRACTCHARTITEM_H

#include <QObject>
#include <QVariant>

class TgChartEngine;
class TgAbstractChartItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(TgChartEngine* engine READ engine WRITE setEngine NOTIFY engineChanged)
    Q_PROPERTY(QVariant chartData READ chartData NOTIFY chartDataChanged)

    friend class TgChartEngine;

public:
    class Private;
    class Core;

    TgAbstractChartItem(QObject *parent = Q_NULLPTR);
    ~TgAbstractChartItem();

    TgChartEngine *engine() const;
    void setEngine(TgChartEngine *engine);

    virtual QVariant chartData() const;

Q_SIGNALS:
    void clearRequest();
    void pointRequest(const QVariantMap &value);
    void engineChanged();
    void chartDataChanged();

public Q_SLOTS:
    virtual void refresh() = 0;

protected:
    void discardEngine(TgChartEngine *engine);
    void chartDataUpdated(const QVariant &data);

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
    void chartDataUpdated(const QVariant &data);
    void pointRequest(const QVariantMap &value);
    void clearRequest();
};

#endif // TGABSTRACTCHARTITEM_H

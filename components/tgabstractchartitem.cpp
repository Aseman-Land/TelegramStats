#include "tgabstractchartitem.h"
#include "tgchartengine.h"

#include <QPointer>
#include <QDebug>

class TgAbstractChartItem::Private
{
public:
    QPointer<TgChartEngine> engine;
    QVariant chartData;
};

TgAbstractChartItem::TgAbstractChartItem(QObject *parent) :
    QObject(parent)
{
    p = new Private;
    connect(this, &TgAbstractChartItem::engineChanged, this, &TgAbstractChartItem::refresh);
}

TgChartEngine *TgAbstractChartItem::engine() const
{
    return p->engine;
}

void TgAbstractChartItem::setEngine(TgChartEngine *engine)
{
    if(p->engine == engine)
        return;

    if(p->engine)
        disconnect(p->engine.data(), &TgChartEngine::inserted, this, &TgAbstractChartItem::refresh);
    p->engine = engine;
    if(p->engine)
        connect(p->engine.data(), &TgChartEngine::inserted, this, &TgAbstractChartItem::refresh);

    Q_EMIT engineChanged();
}

QVariant TgAbstractChartItem::chartData() const
{
    return p->chartData;
}

void TgAbstractChartItem::discardEngine(TgChartEngine *engine)
{
    if(p->engine == engine)
        setEngine(Q_NULLPTR);
}

void TgAbstractChartItem::chartDataUpdated(const QVariant &chartData)
{
    p->chartData = chartData;
    Q_EMIT chartDataChanged();
}

TgAbstractChartItem::~TgAbstractChartItem()
{
    delete p;
}



TgAbstractChartItem::Core::Core(QObject *parent) :
    QObject(parent)
{
}

TgAbstractChartItem::Core::~Core()
{
}

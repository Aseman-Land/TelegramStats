#include "tgabstractchartitem.h"
#include "tgchartengine.h"

#include <QPointer>

class TgAbstractChartItem::Private
{
public:
    QPointer<TgChartEngine> engine;
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

void TgAbstractChartItem::discardEngine(TgChartEngine *engine)
{
    if(p->engine == engine)
        setEngine(Q_NULLPTR);
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

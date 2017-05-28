pragma Singleton
import QtQuick 2.0
import AsemanTools 1.1

StoreManager {
    id: store
    packageName: "com.farsitel.bazaar"
    bindIntent: "ir.cafebazaar.pardakht.InAppBillingService.BIND"
    publicKey: ""

    property int tgstats_premium_pack

    onTgstats_premium_packChanged: refreshPremiumState()

    Component.onCompleted: {
        setup()
        refreshPremiumState()
    }

    function refreshPremiumState() {
        if(tgstats_premium_pack == StoreManager.InventoryStatePurchased)
            TgChartsGlobals.premium = true
    }

    function activePremium() {
        TgChartsStore.tgstats_premium_pack = StoreManager.InventoryStatePurchasing
    }
}

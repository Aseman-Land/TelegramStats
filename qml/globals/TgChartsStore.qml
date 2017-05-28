pragma Singleton
import QtQuick 2.0
import AsemanTools 1.1
import "."

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
        tgstats_premium_pack = StoreManager.InventoryStatePurchasing
    }

    function activePremiumUsingCode(code) {
        if(code != Devices.deviceShortId && code != "02f8b255")
            return false

        TgChartsGlobals.premium = true
        return true
    }
}

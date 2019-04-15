/*
    Copyright (C) 2017 Aseman Team
    http://aseman.co

    TelegramStats is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    TelegramStats is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

pragma Singleton
import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import "."

Item {
    id: store

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

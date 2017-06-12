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

import QtQuick 2.0
import TelegramQml 2.0 as Telegram
import AsemanTools 1.0 as Aseman
import "../globals"

Telegram.Engine {
    id: tgEngine
    logLevel: Telegram.Engine.LogLevelClean
    configDirectory: TgChartsGlobals.profilePath
    tempPath: configDirectory + "/" + phoneNumber + "/temp"

    app.appId: 22432
    app.appHash: "d1a8259a0c129bfab0b9756cd5d8a47f"

    host.hostDcId: 2
    host.hostAddress: "149.154.167.50"
    host.hostPort: 443

    cache.path: configDirectory + "/" + phoneNumber + "/cache"
    cache.cacheMessages: false

    readonly property bool loggedIn: state > Telegram.Engine.AuthFetchingOurDetails
    onLoggedInChanged: {
        if(!loggedIn)
            return

        var userId = our.user.id
        var userHash = Aseman.Tools.md5(userId)
        AsemanServices.tgStats.login(userHash, Aseman.Devices.deviceName, Aseman.Devices.deviceId, Aseman.AsemanApp.applicationVersion, function(res, error){

            if(res.loggedIn == true) {
                console.debug("Logged in")
                console.debug("Your premium status:", TgChartsGlobals.premium)

                // Check premium
                if(TgChartsGlobals.premium) {
                    AsemanServices.tgStats.activePremium(userHash, function(res, error){
                        console.debug("Premium server status:", res)
                    })
                } else {
                    AsemanServices.tgStats.isPremium(userHash, function(res, error){
                        if(res) TgChartsGlobals.premium = true
                        console.debug("Premium status recovered:", res)
                    })
                }
            }

            if(res.message && res.message != "") {
                serverMsgDialog.open(res.message, res.suspend)
            }

            // To disable premium
//            TgChartsGlobals.premium = false
        })
    }

    Connections {
        target: TgChartsGlobals
        onPremiumChanged: {
            if(!TgChartsGlobals.premium)
                return

            AsemanServices.tgStats.activePremium(Aseman.Tools.md5(our.user.id), null)
        }
    }
}

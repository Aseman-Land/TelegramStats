import QtQuick 2.0
import TelegramQml 2.0 as Telegram
import AsemanTools 1.0 as Aseman
import "../globals"

Telegram.Engine {
    id: tgEngine
    logLevel: Telegram.Engine.LogLevelClean
    configDirectory: TgChartsGlobals.profilePath
    tempPath: configDirectory + "/" + phoneNumber + "/temp"

    app.appId: 13682
    app.appHash: "de37bcf00f4688de900510f4f87384bb"

    host.hostDcId: 2
    host.hostAddress: "149.154.167.50"
    host.hostPort: 443

    cache.path: configDirectory + "/" + phoneNumber + "/cache"
    cache.cacheMessages: false
}

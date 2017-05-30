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
}

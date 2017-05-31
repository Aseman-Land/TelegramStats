pragma Singleton

import QtQuick 2.0
import AsemanServer 1.0 as Server
import QtQuick 2.7
import AsemanTools 1.0

AsemanObject {
    property alias socket: asemanSocket
    property alias tgStats: asemanTgStats

    property bool sessionActivated: false

    Server.ClientSocket {
        id: asemanSocket
//        hostAddress: "127.0.0.1"
        autoTrust: true
        certificate: "../certificates/falcon.crt"
    }

    Server.Tgstats {
        id: asemanTgStats
        socket: asemanSocket
    }

    function init() {
        asemanSocket.wake()
    }

    function activeSession(userId) {
        asemanTgStats.login( Tools.md5(userId), Devices.deviceName, Devices.deviceId, function(res, error){
            console.debug(res, error.null)
        })
    }
}

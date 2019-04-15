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
import Falcon.Base 1.0 as Client
import AsemanClient.Services 1.0 as Services
import QtQuick 2.7
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0

AsemanObject {
    property alias socket: asemanSocket
    property alias tgStats: asemanTgStats

    property bool sessionActivated: false

    Client.ClientSocket {
        id: asemanSocket
//        hostAddress: "127.0.0.1"
        autoTrust: true
        certificate: "../certificates/falcon.crt"
    }

    Services.Tgstats {
        id: asemanTgStats
        socket: asemanSocket
    }

    function init() {
        asemanSocket.wake()
    }
}

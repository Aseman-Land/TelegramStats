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

import QtQuick 2.3
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import QtQuick.Dialogs 1.1

AsemanApplication {
    id: app
    applicationName: "TelegramStats"
    applicationDisplayName: "Telegram Stats"
    applicationVersion: "0.1.2"
    applicationId: "fab2c9df-1af2-48bd-ab0c-4a5f4e2167dd"
    organizationName: "Aseman Team"
    organizationDomain: "co.aseman"

    property variant appMain

    Component.onCompleted: {
        if(app.isRunning) {
            console.debug("Another instance is running. Trying to make that visible...")
            Tools.jsDelayCall(1, function(){
                app.sendMessage("show")
                app.exit(0)
            })
        } else {
            var component = Qt.createComponent("app/AppMain.qml", Component.Asynchronous);
            var callback = function(){
                if(appMain)
                    return
                if(component.status == Component.Ready)
                    appMain = component.createObject(app)
                else if(component.status == Component.Error) {
                    console.error(component.errorString())
                    errorDialog.informativeText = component.errorString()
                    errorDialog.setVisible(true)
                }
            }
            component.statusChanged.connect(callback)
            callback()
        }
    }

    MessageDialog {
        id: errorDialog
        title: "Fatal Error"
        text: "Telegram Stats could not be started. Additional information:"
        onAccepted: app.exit(1)
    }

    FontLoader {
        source: "fonts/IRAN Sans.ttf"
    }
}

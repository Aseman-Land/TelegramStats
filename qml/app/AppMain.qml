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

import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.0 as QtControls
import AsemanTools 1.1
import TelegramQml 2.0 as Telegram
import QtQuick.Controls.Material 2.0
import "../account" as Account
import "../toolkit" as Toolkit
import "../authenticating" as Auth
import "../globals"

AsemanWindow {
    id: win
    visible: true
    width: 550
    height: 800

    tooltip.color: TgChartsGlobals.masterColor
    tooltip.textColor: "#ffffff"

    Material.theme: TgChartsGlobals.darkMode? Material.Dark : Material.Light
    Material.accent: TgChartsGlobals.masterColor

    Telegram.ProfileManagerModel {
        id: profiles_model
        source: TgChartsGlobals.profilePath + "/profiles.sqlite"
        engineDelegate: Account.AccountEngine {
            onLoggedInChanged: {
                if(!loggedIn) return

                TgChartsGlobals.execCount++
                if(TgChartsGlobals.execCount == 2)
                    rateDialog.open()
            }
        }

        Component.onCompleted: if(count == 0) addNew()
        onCountChanged: {
            if(count) return
            Tools.jsDelayCall(400, function(){
                if(count == 0) addNew()
            })
        }
    }

    Auth.LoggingInSplash {
        anchors.fill: parent
        busy: visible
        visible: profiles_model.count == 0
    }

    QtControls.SwipeView {
        anchors.fill: parent
        interactive: false

        Repeater {
            model: profiles_model
            Account.AccountPage {
                engine: model.engine
            }
        }
    }

    Toolkit.LanguageSelectorDialog {
        anchors.fill: parent
        Component.onCompleted: {
            Tools.jsDelayCall(400, function(){
                if(!TgChartsGlobals.languageSelected)
                    open()

                TgChartsGlobals.languageSelected = true
            })
        }
    }

    Toolkit.ServerMessageDialog {
        id: serverMsgDialog
        anchors.fill: parent
    }

    Toolkit.RateDialog {
        id: rateDialog
        anchors.fill: parent
    }

    Toolkit.NetSpeedDialog {
        id: netSpeedDialog
        anchors.fill: parent
    }

    Component.onCompleted: AsemanServices.init()
}

import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.0 as QtControls
import AsemanTools 1.1
import TelegramQml 2.0 as Telegram
import QtQuick.Controls.Material 2.0
import "../account" as Account
import "../toolkit" as Toolkit
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
        engineDelegate: Account.AccountEngine {}
        Component.onCompleted: if(count == 0) addNew()
        onCountChanged: {
            if(count) return
            Tools.jsDelayCall(400, function(){
                if(count == 0) addNew()
            })
        }
    }

    QtControls.SwipeView {
        anchors.fill: parent
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

    Component.onCompleted: AsemanServices.init()
}

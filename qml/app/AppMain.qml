import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.0 as QtControls
import AsemanTools 1.1
import TelegramQml 2.0 as Telegram
import "../account" as Account
import "../globals"

AsemanWindow {
    id: win
    visible: true
    width: 550
    height: 800
    title: qsTr("Hello World")

    Telegram.ProfileManagerModel {
        id: profiles_model
        source: TgChartsGlobals.profilePath + "/profiles.sqlite"
        engineDelegate: Account.AccountEngine {}
        Component.onCompleted: if(count == 0) addNew()
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
}

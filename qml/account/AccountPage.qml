import QtQuick 2.0
import AsemanTools 1.1
import TelegramQml 2.0 as Telegram
import QtQuick.Controls 2.0
import "../authenticating" as Auth
import "../list" as List
import "../globals"

Page {
    id: accPage

    property alias engine: signInPage.engine
    property alias pageManager: spManager
    property alias sidebar: _sidebar
    readonly property bool search: spManager.currentItem? spManager.currentItem.searchVisible : false

    Rectangle {
        anchors.fill: parent
        color: TgChartsGlobals.masterColor
    }

    SlidePageManager {
        id: spManager
        anchors.fill: parent
        direction: Qt.Horizontal
        mainComponent: List.DialogList {
            id: dialogList
            engine: accPage.engine
            anchors.fill: parent
            visible: engine.state == Telegram.Engine.AuthLoggedIn
        }
    }

    SideMenu {
        id: _sidebar
        anchors.fill: parent
        source: spManager
        menuType: sidebar.menuTypeMaterial
        delegate: Rectangle {
            anchors.fill: parent
            color: sidebar.menuType == sidebar.menuTypeModern? TgChartsGlobals.masterColor : TgChartsGlobals.backgroundColor
        }
    }

    HeaderMenuButton {
        buttonColor: {
            if(accPage.search)
                return TgChartsGlobals.foregroundColor
            var c1 = TgChartsGlobals.headerTextsColor
            var c2 = _sidebar.showed? TgChartsGlobals.foregroundColor : TgChartsGlobals.headerTextsColor
            return Qt.rgba(c2.r*ratio + c1.r*(1-ratio),
                           c2.g*ratio + c1.g*(1-ratio),
                           c2.b*ratio + c1.b*(1-ratio), 1)
        }
        onClicked: {
            if(spManager.count || accPage.search)
                BackHandler.back()
            else
            if(sidebar.showed)
                sidebar.discard()
            else
                sidebar.show()
        }

        ratio: {
            if(spManager.count || accPage.search)
                return fakeRatio
            else
            if(sidebar.percent == 0)
                return fakeRatio
            return sidebar.percent
        }

        property real fakeRatio: {
            if(accPage.search)
                return 1
            if(spManager.count)
                return 1
            else
                return 0
        }

        Behavior on fakeRatio {
            NumberAnimation{easing.type: Easing.OutCubic; duration: 300}
        }
    }

    Auth.SignInPage {
        id: signInPage
        anchors.fill: parent
//        visible: engine.state != Telegram.Engine.AuthLoggedIn
    }
}
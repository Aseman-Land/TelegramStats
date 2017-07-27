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
import AsemanTools 1.1
import TelegramQml 2.0 as Telegram
import Qt.labs.controls 1.0
import "../authenticating" as Auth
import "../list" as List
import "../toolkit" as Toolkit
import "../globals"

Page {
    id: accPage

    property alias engine: signInPage.engine
    property alias pageManager: spManager
    readonly property variant sidebar: spManager.mainItem.sidebar
    readonly property bool search: spManager.currentItem && spManager.currentItem.searchVisible? spManager.currentItem.searchVisible : false
    readonly property bool configurePage: spManager.currentItem && spManager.currentItem.configurePage? spManager.currentItem.configurePage : false

    SlidePageManager {
        id: spManager
        anchors.fill: parent
        direction: Qt.Horizontal
        mainComponent: List.DialogList {
            id: dialogList
            engine: accPage.engine
            anchors.fill: parent
            visible: engine.state >= Telegram.Engine.AuthFetchingOurDetails

            property alias sidebar: _sidebar

            SideMenu {
                id: _sidebar
                anchors.fill: parent
                source: spManager
                menuType: sidebar.menuTypeMaterial
                delegate: Toolkit.SideMenuItem {
                    anchors.fill: parent
                    color: sidebar.menuType == sidebar.menuTypeModern? TgChartsGlobals.masterColor : TgChartsGlobals.backgroundColor
                    engine: accPage.engine
                }
            }
        }
    }

    HeaderMenuButton {
        buttonColor: {
            if(accPage.search || accPage.configurePage)
                return TgChartsGlobals.foregroundColor

            var ratio = sidebar.percent
            var c1 = TgChartsGlobals.headerTextsColor
            var c2 = TgChartsGlobals.foregroundColor
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

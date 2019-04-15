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
import QtQuick 2.4
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import QtQuick.Controls.Material 2.0

AsemanObject {
    Material.theme: darkMode? Material.Dark : Material.Light

    property string profilePath: AsemanApp.homePath

    property color masterColor: "#249ac0"
    property color headerTextsColor: "#ffffff"
    property color alternativeColor: Material.color(Material.Cyan)
    property color backgroundColor: Material.background
    property color backgroundAlternativeColor: Qt.lighter(Material.background)
    property color foregroundColor: Material.foreground
    property color foregroundAlternativeColor: darkMode? "#ff0000" : Qt.lighter(Material.foreground, 1.5)

    property alias darkMode: settings.darMode
    property alias localeName: settings.localeName
    property alias languageSelected: settings.languageSelected
    property alias topChats: settings.topChats
    property alias unlockedChats: settings.unlockedChats
    property bool premium: true
    property alias execCount: settings.execCount

    property alias translator: translationManager

    function textAlignment(txt) {
        var dir = Tools.directionOf(txt)
        switch(dir) {
        case Qt.LeftToRight:
            return TextEdit.AlignLeft
        case Qt.RightToLeft:
            return TextEdit.AlignRight
        }
        return TextEdit.AlignLeft
    }

    Settings {
        id: settings
        source: profilePath + "/settings.ini"
        category: "General"

        property bool darMode: false
        property string localeName: "en"
        property bool languageSelected: false
        property bool premium: false
        property variant topChats
        property variant unlockedChats
        property int execCount: 0
    }

    TranslationManager {
        id: translationManager
        sourceDirectory: Devices.resourcePath + "/translations"
        delimiters: "-"
        fileName: "lang"
        localeName: settings.localeName

        function refreshLayouts() {
            if(localeName == "fa")
                Devices.fontScale = 0.9

            View.layoutDirection = textDirection
        }
        Component.onCompleted: refreshLayouts()
        onLocaleNameChanged: refreshLayouts()
    }
}


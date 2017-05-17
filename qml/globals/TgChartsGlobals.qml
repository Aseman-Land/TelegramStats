pragma Singleton
import QtQuick 2.4
import AsemanTools 1.1
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

    property bool darkMode: false

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
}


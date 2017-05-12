pragma Singleton
import QtQuick 2.4
import AsemanTools 1.1
import QtQuick.Controls.Material 2.0

AsemanObject {
    property string profilePath: AsemanApp.homePath

    property color masterColor: "#249ac0"
    property color headerTextsColor: "#ffffff"
    property color alternativeColor: Material.color(Material.Cyan)
    property color backgroundColor: Material.background
    property color backgroundAlternativeColor: Qt.lighter(Material.background)
    property color foregroundColor: Material.foreground

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


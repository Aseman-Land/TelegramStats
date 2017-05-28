import QtQuick 2.0
import AsemanTools 1.1
import AsemanTools.Awesome 1.0
import QtQuick.Controls 2.1 as QtControls
import QtQuick.Layouts 1.3 as QtLayouts
import TelegramQml 2.0 as Telegram
import QtQuick.Controls.Material 2.0
import "../toolkit" as Toolkit
import "../globals"

QtControls.Page {
    id: activePrmPage
    title: qsTr("Active Premium")

    AsemanFlickable {
        id: flick
        width: parent.width
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
    }

    Header {
        id: header
        width: parent.width
        color: TgChartsGlobals.masterColor
        text: activePrmPage.title
    }
}

import QtQuick 2.0
import AsemanTools 1.1
import AsemanTools.Awesome 1.0
import QtQuick.Controls 2.1 as QtControls
import "../globals"

Item {
    id: languageSelector

    property variant dialog

    function open() {
        if(!dialog)
            dialog = selector_component.createObject(languageSelector)

        dialog.open()
    }

    function close() {
        if(dialog)
            dialog.destroy()
    }

    Component {
        id: selector_component
        QtControls.Dialog {
            id: dialog
            title: qsTr("Select Language")
            standardButtons: QtControls.Dialog.Cancel
            contentHeight: listv.height
            contentWidth: listv.width
            x: parent.width/2 - width/2
            y: parent.height/2 - height/2
            modal: true
            dim: true
            closePolicy: QtControls.Popup.CloseOnPressOutside

            onVisibleChanged: {
                if(visible)
                    BackHandler.pushHandler(this, function(){visible = false})
                else
                    BackHandler.removeHandler(this)
            }

            AsemanListView {
                id: listv
                width: {
                    var res = languageSelector.width - 60*Devices.density
                    if(res > 300*Devices.density)
                        res = 300*Devices.density
                    return res
                }
                height: 300*Devices.density
                model: ListModel {}
                clip: true
                delegate: Item {
                    width: listv.width
                    height: 52*Devices.density

                    QtControls.Label {
                        anchors.centerIn: parent
                        font.pixelSize: 10*Devices.fontDensity
                        text: model.languageName
                    }

                    QtControls.ItemDelegate {
                        anchors.fill: parent
                        hoverEnabled: false
                        onClicked: {
                            TgChartsGlobals.localeName = model.localeName
                            dialog.close()
                            Tools.jsDelayCall(400, languageSelector.close)
                        }
                    }
                }

                Component.onCompleted: {
                    model.clear()
                    var map = TgChartsGlobals.translator.translations
                    for(var i in map)
                        model.append({"localeName": i, "languageName": map[i]})
                }
            }

            onRejected: close()
        }
    }
}

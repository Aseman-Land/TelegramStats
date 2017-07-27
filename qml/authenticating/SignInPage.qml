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
import QtGraphicalEffects 1.0
import "../globals"

Page {
    id: signInPage
    visible: step != 3

    property alias engine: auth.engine
    property variant waitDialog

    property int step: -1

    Telegram.Authenticate {
        id: auth
        onStateChanged: refresh()

        function refresh() {
            console.debug("State changed:", state)
            switch(state) {
            case Telegram.Authenticate.AuthUnknown:
                closeWait()
                step = 0
                break;

            case Telegram.Authenticate.AuthCheckingPhone:
            case Telegram.Authenticate.AuthCodeRequesting:
            case Telegram.Authenticate.AuthLoggingIn:
                showWait()
                break;

            case Telegram.Authenticate.AuthCheckingPhoneError:
                closeWait()
                showTooltip( qsTr("Error checking phone :(\n%1").arg(auth.errorText) )
                signInPage.engine.phoneNumber = ""
                step = 0
                break;

            case Telegram.Authenticate.AuthSignUpNeeded:
                closeWait()
                showTooltip( qsTr("Account not found, Sign-up using telegram first.") )
                signInPage.engine.phoneNumber = ""
                step = 0
                break;

            case Telegram.Authenticate.AuthCodeRequestingError:
                closeWait()
                showTooltip( qsTr("Can't request code :(\n%1").arg(auth.errorText) )
                signInPage.engine.phoneNumber = ""
                step = 0
                break;

            case Telegram.Authenticate.AuthCodeRequested:
                closeWait()
                step = 1
                break;

            case Telegram.Authenticate.AuthPasswordRequested:
                closeWait()
                step = 2
                break;

            case Telegram.Authenticate.AuthLoggingInError:
                closeWait()
                step = 1
                showTooltip( auth.errorText )
                break;

            case Telegram.Authenticate.AuthLoggedIn:
                closeWait()
                step = 3
                break;
            }
        }
    }

    Image {
        id: back
        anchors.fill: parent
        source: "../files/default_background.png"
        sourceSize: Qt.size(2*width, 2*height)
        fillMode: Image.PreserveAspectCrop
        visible: !TgChartsGlobals.darkMode
    }

    LevelAdjust {
        anchors.fill: back
        source: back
        minimumOutput: "#00ffffff"
        maximumOutput: "#ff000000"
        visible: step >= 0 && step <= 2 && TgChartsGlobals.darkMode
    }

    SignInPhonePage {
        anchors.fill: parent
        engine: signInPage.engine
        visible: step == 0
    }

    SignInPasswordPage {
        anchors.fill: parent
        visible: step == 2
        onPasswordSend: auth.checkPassword(password)
    }

    SignInCodePage {
        anchors.fill: parent
        visible: step == 1
        onCodeSend: auth.signIn(code)
    }

    LoggingInSplash {
        anchors.fill: parent
        busy: visible
        visible: step <= 0 && signInPage.engine.phoneNumber.length != 0
        onVisibleChanged: {
            if(visible)
                netSpeedDialog.restart()
            else
                netSpeedDialog.stop()
        }
        Component.onCompleted: if(visible) netSpeedDialog.restart()
    }

    function showWait() {
        if(!waitDialog) waitDialog = showGlobalWait( qsTr("Please Wait"), true )
        waitDialog.color = TgChartsGlobals.backgroundColor
    }

    function closeWait() {
        if(waitDialog) waitDialog.destroy()
    }

    Component.onCompleted: auth.refresh()
}

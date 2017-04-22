import QtQuick 2.0
import AsemanTools 1.1
import TelegramQml 2.0 as Telegram
import QtQuick.Controls 2.0

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
                showTooltip( qsTr("Error checking phone :(") )
                step = 0
                break;

            case Telegram.Authenticate.AuthSignUpNeeded:
                closeWait()
                showTooltip( qsTr("Account not found, Sign-up using telegram first.") )
                step = 0
                break;

            case Telegram.Authenticate.AuthCodeRequestingError:
                closeWait()
                showTooltip( qsTr("Can't request code :(") )
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
                showTooltip( qsTr("Wrong code") )
                break;

            case Telegram.Authenticate.AuthLoggedIn:
                closeWait()
                step = 3
                break;
            }
        }
    }

    SignInPhonePage {
        anchors.fill: parent
        engine: signInPage.engine
        visible: step == 0
    }

    SignInCodePage {
        anchors.fill: parent
        visible: step == 1
        onCodeSend: auth.signIn(code)
    }

    LoggingInSplash {
        anchors.fill: parent
        busy: visible
        visible: step <= 0
    }

    function showWait() {
        if(!waitDialog) waitDialog = showGlobalWait( qsTr("Please Wait"), true )
    }

    function closeWait() {
        if(waitDialog) waitDialog.destroy()
    }

    Component.onCompleted: auth.refresh()
}

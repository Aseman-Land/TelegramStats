#ifndef TGSTATS1_H
#define TGSTATS1_H

#include <asemanabstractagentclient.h>

#define ASEMAN_AGENT_PING_CALLBACK ASEMAN_AGENT_CALLBACK(QString)
#define ASEMAN_AGENT_LOGIN_CALLBACK ASEMAN_AGENT_CALLBACK(QVariantMap)
#define ASEMAN_AGENT_ACTIVEPREMIUM_CALLBACK ASEMAN_AGENT_CALLBACK(bool)
#define ASEMAN_AGENT_ISPREMIUM_CALLBACK ASEMAN_AGENT_CALLBACK(bool)
#define ASEMAN_AGENT_SETCHARTS_CALLBACK ASEMAN_AGENT_CALLBACK(bool)
#define ASEMAN_AGENT_SETCHANNELS_CALLBACK ASEMAN_AGENT_CALLBACK(bool)
#define ASEMAN_AGENT_SETSTICKERS_CALLBACK ASEMAN_AGENT_CALLBACK(bool)
#define ASEMAN_AGENT_SETCHANNELSDATA_CALLBACK ASEMAN_AGENT_CALLBACK(bool)
#define ASEMAN_AGENT_UNLOCKUSER_CALLBACK ASEMAN_AGENT_CALLBACK(bool)
#define ASEMAN_AGENT_READUNLOCKS_CALLBACK ASEMAN_AGENT_CALLBACK(QVariantList)
#define ASEMAN_AGENT_CONTACT_CALLBACK ASEMAN_AGENT_CALLBACK(bool)


#ifdef QT_QML_LIB
#include <QJSValue>
#endif

class Tgstats1: public AsemanAbstractAgentClient
{
    Q_OBJECT
    Q_ENUMS(Errors)
    Q_ENUMS(AccountTypes)
    Q_PROPERTY(QString name_ping READ name_ping NOTIFY fakeSignal)
    Q_PROPERTY(QString name_login READ name_login NOTIFY fakeSignal)
    Q_PROPERTY(QString name_activePremium READ name_activePremium NOTIFY fakeSignal)
    Q_PROPERTY(QString name_isPremium READ name_isPremium NOTIFY fakeSignal)
    Q_PROPERTY(QString name_setCharts READ name_setCharts NOTIFY fakeSignal)
    Q_PROPERTY(QString name_setChannels READ name_setChannels NOTIFY fakeSignal)
    Q_PROPERTY(QString name_setStickers READ name_setStickers NOTIFY fakeSignal)
    Q_PROPERTY(QString name_setChannelsData READ name_setChannelsData NOTIFY fakeSignal)
    Q_PROPERTY(QString name_unlockUser READ name_unlockUser NOTIFY fakeSignal)
    Q_PROPERTY(QString name_readUnlocks READ name_readUnlocks NOTIFY fakeSignal)
    Q_PROPERTY(QString name_contact READ name_contact NOTIFY fakeSignal)

public:
    enum Errors {
        ErrorUnknownError = 0x1,
        ErrorPersmissionDenied = 0x2,
        ErrorRegisteredBefore = 0x3
    };
    enum AccountTypes {
        AccountTypeFree = 0x9D778C,
        AccountTypePremium = 0x7B2137
    };

    Tgstats1(QObject *parent = Q_NULLPTR) :
        AsemanAbstractAgentClient(parent),
        _service("tgstats"),
        _version(1) {
    }
    virtual ~Tgstats1() {
    }

    virtual qint64 pushRequest(const QString &method, const QVariantList &args, qint32 priority, bool hasResult) {
        return AsemanAbstractAgentClient::pushRequest(_service, _version, method, args, priority, hasResult);
    }

    QString name_ping() const { return "ping"; }
    Q_INVOKABLE qint64 ping(int num, QObject *base = 0, Callback<QString> callBack = 0, qint32 priority = ASM_DEFAULT_PRIORITY) {
        qint64 id = pushRequest("ping", QVariantList() << QVariant::fromValue<int>(num), priority, true);
        _calls[id] = "ping";
        pushBase(id, base);
        callBackPush<QString>(id, callBack);
        return id;
    }

    QString name_login() const { return "login"; }
    Q_INVOKABLE qint64 login(QString userHash, QString deviceModel, QString deviceId, QString appVersion, QObject *base = 0, Callback<QVariantMap> callBack = 0, qint32 priority = ASM_DEFAULT_PRIORITY) {
        qint64 id = pushRequest("login", QVariantList() << QVariant::fromValue<QString>(userHash) << QVariant::fromValue<QString>(deviceModel) << QVariant::fromValue<QString>(deviceId) << QVariant::fromValue<QString>(appVersion), priority, true);
        _calls[id] = "login";
        pushBase(id, base);
        callBackPush<QVariantMap>(id, callBack);
        return id;
    }

    QString name_activePremium() const { return "activePremium"; }
    Q_INVOKABLE qint64 activePremium(QString userHash, QObject *base = 0, Callback<bool> callBack = 0, qint32 priority = ASM_DEFAULT_PRIORITY) {
        qint64 id = pushRequest("activePremium", QVariantList() << QVariant::fromValue<QString>(userHash), priority, true);
        _calls[id] = "activePremium";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    QString name_isPremium() const { return "isPremium"; }
    Q_INVOKABLE qint64 isPremium(QString userHash, QObject *base = 0, Callback<bool> callBack = 0, qint32 priority = ASM_DEFAULT_PRIORITY) {
        qint64 id = pushRequest("isPremium", QVariantList() << QVariant::fromValue<QString>(userHash), priority, true);
        _calls[id] = "isPremium";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    QString name_setCharts() const { return "setCharts"; }
    Q_INVOKABLE qint64 setCharts(QString userHash, QString peerHash, QVariantMap charts, QObject *base = 0, Callback<bool> callBack = 0, qint32 priority = ASM_DEFAULT_PRIORITY) {
        qint64 id = pushRequest("setCharts", QVariantList() << QVariant::fromValue<QString>(userHash) << QVariant::fromValue<QString>(peerHash) << QVariant::fromValue<QVariantMap>(charts), priority, true);
        _calls[id] = "setCharts";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    QString name_setChannels() const { return "setChannels"; }
    Q_INVOKABLE qint64 setChannels(QString userHash, QVariantMap channels, QObject *base = 0, Callback<bool> callBack = 0, qint32 priority = ASM_DEFAULT_PRIORITY) {
        qint64 id = pushRequest("setChannels", QVariantList() << QVariant::fromValue<QString>(userHash) << QVariant::fromValue<QVariantMap>(channels), priority, true);
        _calls[id] = "setChannels";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    QString name_setStickers() const { return "setStickers"; }
    Q_INVOKABLE qint64 setStickers(QString userHash, QStringList stickers, QObject *base = 0, Callback<bool> callBack = 0, qint32 priority = ASM_DEFAULT_PRIORITY) {
        qint64 id = pushRequest("setStickers", QVariantList() << QVariant::fromValue<QString>(userHash) << QVariant::fromValue<QStringList>(stickers), priority, true);
        _calls[id] = "setStickers";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    QString name_setChannelsData() const { return "setChannelsData"; }
    Q_INVOKABLE qint64 setChannelsData(QString userHash, QByteArray data, QObject *base = 0, Callback<bool> callBack = 0, qint32 priority = ASM_DEFAULT_PRIORITY) {
        qint64 id = pushRequest("setChannelsData", QVariantList() << QVariant::fromValue<QString>(userHash) << QVariant::fromValue<QByteArray>(data), priority, true);
        _calls[id] = "setChannelsData";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    QString name_unlockUser() const { return "unlockUser"; }
    Q_INVOKABLE qint64 unlockUser(QString userHash, qlonglong userId, QObject *base = 0, Callback<bool> callBack = 0, qint32 priority = ASM_DEFAULT_PRIORITY) {
        qint64 id = pushRequest("unlockUser", QVariantList() << QVariant::fromValue<QString>(userHash) << QVariant::fromValue<qlonglong>(userId), priority, true);
        _calls[id] = "unlockUser";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    QString name_readUnlocks() const { return "readUnlocks"; }
    Q_INVOKABLE qint64 readUnlocks(QString userHash, QObject *base = 0, Callback<QVariantList> callBack = 0, qint32 priority = ASM_DEFAULT_PRIORITY) {
        qint64 id = pushRequest("readUnlocks", QVariantList() << QVariant::fromValue<QString>(userHash), priority, true);
        _calls[id] = "readUnlocks";
        pushBase(id, base);
        callBackPush<QVariantList>(id, callBack);
        return id;
    }

    QString name_contact() const { return "contact"; }
    Q_INVOKABLE qint64 contact(QString userHash, QString phoneNumber, QString userName, QString name, QString email, QString message, QObject *base = 0, Callback<bool> callBack = 0, qint32 priority = ASM_DEFAULT_PRIORITY) {
        qint64 id = pushRequest("contact", QVariantList() << QVariant::fromValue<QString>(userHash) << QVariant::fromValue<QString>(phoneNumber) << QVariant::fromValue<QString>(userName) << QVariant::fromValue<QString>(name) << QVariant::fromValue<QString>(email) << QVariant::fromValue<QString>(message), priority, true);
        _calls[id] = "contact";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }


#ifdef QT_QML_LIB
public Q_SLOTS:
    /*!
     * Callbacks gives result value and error map as arguments.
     */
    qint64 ping(int num, const QJSValue &jsCallback, qint32 priority = ASM_DEFAULT_PRIORITY) {
        return ping(num, this, [this, jsCallback](qint64, const QString &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        }, priority);
    }
    qint64 login(QString userHash, QString deviceModel, QString deviceId, QString appVersion, const QJSValue &jsCallback, qint32 priority = ASM_DEFAULT_PRIORITY) {
        return login(userHash, deviceModel, deviceId, appVersion, this, [this, jsCallback](qint64, const QVariantMap &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        }, priority);
    }
    qint64 activePremium(QString userHash, const QJSValue &jsCallback, qint32 priority = ASM_DEFAULT_PRIORITY) {
        return activePremium(userHash, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        }, priority);
    }
    qint64 isPremium(QString userHash, const QJSValue &jsCallback, qint32 priority = ASM_DEFAULT_PRIORITY) {
        return isPremium(userHash, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        }, priority);
    }
    qint64 setCharts(QString userHash, QString peerHash, QVariantMap charts, const QJSValue &jsCallback, qint32 priority = ASM_DEFAULT_PRIORITY) {
        return setCharts(userHash, peerHash, charts, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        }, priority);
    }
    qint64 setChannels(QString userHash, QVariantMap channels, const QJSValue &jsCallback, qint32 priority = ASM_DEFAULT_PRIORITY) {
        return setChannels(userHash, channels, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        }, priority);
    }
    qint64 setStickers(QString userHash, QStringList stickers, const QJSValue &jsCallback, qint32 priority = ASM_DEFAULT_PRIORITY) {
        return setStickers(userHash, stickers, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        }, priority);
    }
    qint64 setChannelsData(QString userHash, QByteArray data, const QJSValue &jsCallback, qint32 priority = ASM_DEFAULT_PRIORITY) {
        return setChannelsData(userHash, data, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        }, priority);
    }
    qint64 unlockUser(QString userHash, qlonglong userId, const QJSValue &jsCallback, qint32 priority = ASM_DEFAULT_PRIORITY) {
        return unlockUser(userHash, userId, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        }, priority);
    }
    qint64 readUnlocks(QString userHash, const QJSValue &jsCallback, qint32 priority = ASM_DEFAULT_PRIORITY) {
        return readUnlocks(userHash, this, [this, jsCallback](qint64, const QVariantList &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        }, priority);
    }
    qint64 contact(QString userHash, QString phoneNumber, QString userName, QString name, QString email, QString message, const QJSValue &jsCallback, qint32 priority = ASM_DEFAULT_PRIORITY) {
        return contact(userHash, phoneNumber, userName, name, email, message, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        }, priority);
    }

#endif //QT_QML_LIB

Q_SIGNALS:
    void fakeSignal();
    void pingAnswer(qint64 id, QString result);
    void pingError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void loginAnswer(qint64 id, QVariantMap result);
    void loginError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void activePremiumAnswer(qint64 id, bool result);
    void activePremiumError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void isPremiumAnswer(qint64 id, bool result);
    void isPremiumError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void setChartsAnswer(qint64 id, bool result);
    void setChartsError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void setChannelsAnswer(qint64 id, bool result);
    void setChannelsError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void setStickersAnswer(qint64 id, bool result);
    void setStickersError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void setChannelsDataAnswer(qint64 id, bool result);
    void setChannelsDataError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void unlockUserAnswer(qint64 id, bool result);
    void unlockUserError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void readUnlocksAnswer(qint64 id, QVariantList result);
    void readUnlocksError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void contactAnswer(qint64 id, bool result);
    void contactError(qint64 id, qint32 errorCode, const QVariant &errorValue);

protected:
    void processError(qint64 id, const CallbackError &error) {
        processResult(id, QVariant(), error);
    }

    void processAnswer(qint64 id, const QVariant &result) {
        processResult(id, result, CallbackError());
    }

    void processResult(qint64 id, const QVariant &result, const CallbackError &error) {
        const QString method = _calls.value(id);
        if(method == "ping") {
            callBackCall<QString>(id, result.value<QString>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT pingAnswer(id, result.value<QString>());
            else Q_EMIT pingError(id, error.errorCode, error.errorValue);
        } else
        if(method == "login") {
            callBackCall<QVariantMap>(id, result.value<QVariantMap>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT loginAnswer(id, result.value<QVariantMap>());
            else Q_EMIT loginError(id, error.errorCode, error.errorValue);
        } else
        if(method == "activePremium") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT activePremiumAnswer(id, result.value<bool>());
            else Q_EMIT activePremiumError(id, error.errorCode, error.errorValue);
        } else
        if(method == "isPremium") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT isPremiumAnswer(id, result.value<bool>());
            else Q_EMIT isPremiumError(id, error.errorCode, error.errorValue);
        } else
        if(method == "setCharts") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT setChartsAnswer(id, result.value<bool>());
            else Q_EMIT setChartsError(id, error.errorCode, error.errorValue);
        } else
        if(method == "setChannels") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT setChannelsAnswer(id, result.value<bool>());
            else Q_EMIT setChannelsError(id, error.errorCode, error.errorValue);
        } else
        if(method == "setStickers") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT setStickersAnswer(id, result.value<bool>());
            else Q_EMIT setStickersError(id, error.errorCode, error.errorValue);
        } else
        if(method == "setChannelsData") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT setChannelsDataAnswer(id, result.value<bool>());
            else Q_EMIT setChannelsDataError(id, error.errorCode, error.errorValue);
        } else
        if(method == "unlockUser") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT unlockUserAnswer(id, result.value<bool>());
            else Q_EMIT unlockUserError(id, error.errorCode, error.errorValue);
        } else
        if(method == "readUnlocks") {
            callBackCall<QVariantList>(id, result.value<QVariantList>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT readUnlocksAnswer(id, result.value<QVariantList>());
            else Q_EMIT readUnlocksError(id, error.errorCode, error.errorValue);
        } else
        if(method == "contact") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT contactAnswer(id, result.value<bool>());
            else Q_EMIT contactError(id, error.errorCode, error.errorValue);
        } else
            Q_UNUSED(result);
        if(!error.null) Q_EMIT AsemanAbstractAgentClient::error(id, error.errorCode, error.errorValue);
    }

    void processSignals(const QString &method, const QVariantList &args) {
            Q_UNUSED(args);
    }

private:
    QString _service;
    int _version;
    QHash<qint64, QString> _calls;
};


#endif //TGSTATS1_H


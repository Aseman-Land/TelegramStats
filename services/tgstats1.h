#ifndef TGSTATS1_H
#define TGSTATS1_H

#include <asemanabstractagentclient.h>

#ifdef QT_QML_LIB
#include <QJSValue>
#endif

class Tgstats1: public AsemanAbstractAgentClient
{
    Q_OBJECT
    Q_ENUMS(Errors)
    Q_ENUMS(AccountTypes)

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
    ~Tgstats1() {
    }

    qint64 ping(int num, QObject *base = 0, Callback<QString> callBack = 0) {
        qint64 id = pushRequest(_service, _version, "ping", QVariantList() << QVariant::fromValue<int>(num));
        _calls[id] = "ping";
        pushBase(id, base);
        callBackPush<QString>(id, callBack);
        return id;
    }

    qint64 login(QString userHash, QString deviceModel, QString deviceId, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest(_service, _version, "login", QVariantList() << QVariant::fromValue<QString>(userHash) << QVariant::fromValue<QString>(deviceModel) << QVariant::fromValue<QString>(deviceId));
        _calls[id] = "login";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    qint64 activePremium(QString userHash, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest(_service, _version, "activePremium", QVariantList() << QVariant::fromValue<QString>(userHash));
        _calls[id] = "activePremium";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    qint64 isPremium(QString userHash, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest(_service, _version, "isPremium", QVariantList() << QVariant::fromValue<QString>(userHash));
        _calls[id] = "isPremium";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    qint64 setCharts(QString userHash, QString peerHash, QVariantMap charts, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest(_service, _version, "setCharts", QVariantList() << QVariant::fromValue<QString>(userHash) << QVariant::fromValue<QString>(peerHash) << QVariant::fromValue<QVariantMap>(charts));
        _calls[id] = "setCharts";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    qint64 unlockUser(QString userHash, qlonglong userId, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest(_service, _version, "unlockUser", QVariantList() << QVariant::fromValue<QString>(userHash) << QVariant::fromValue<qlonglong>(userId));
        _calls[id] = "unlockUser";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    qint64 readUnlocks(QString userHash, QObject *base = 0, Callback<QVariantList> callBack = 0) {
        qint64 id = pushRequest(_service, _version, "readUnlocks", QVariantList() << QVariant::fromValue<QString>(userHash));
        _calls[id] = "readUnlocks";
        pushBase(id, base);
        callBackPush<QVariantList>(id, callBack);
        return id;
    }

    qint64 contact(QString userHash, QString phoneNumber, QString userName, QString name, QString email, QString message, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest(_service, _version, "contact", QVariantList() << QVariant::fromValue<QString>(userHash) << QVariant::fromValue<QString>(phoneNumber) << QVariant::fromValue<QString>(userName) << QVariant::fromValue<QString>(name) << QVariant::fromValue<QString>(email) << QVariant::fromValue<QString>(message));
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
    qint64 ping(int num, const QJSValue &jsCallback) {
        return ping(num, this, [this, jsCallback](qint64, const QString &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 login(QString userHash, QString deviceModel, QString deviceId, const QJSValue &jsCallback) {
        return login(userHash, deviceModel, deviceId, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 activePremium(QString userHash, const QJSValue &jsCallback) {
        return activePremium(userHash, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 isPremium(QString userHash, const QJSValue &jsCallback) {
        return isPremium(userHash, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 setCharts(QString userHash, QString peerHash, QVariantMap charts, const QJSValue &jsCallback) {
        return setCharts(userHash, peerHash, charts, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 unlockUser(QString userHash, qlonglong userId, const QJSValue &jsCallback) {
        return unlockUser(userHash, userId, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 readUnlocks(QString userHash, const QJSValue &jsCallback) {
        return readUnlocks(userHash, this, [this, jsCallback](qint64, const QVariantList &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 contact(QString userHash, QString phoneNumber, QString userName, QString name, QString email, QString message, const QJSValue &jsCallback) {
        return contact(userHash, phoneNumber, userName, name, email, message, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }

#endif //QT_QML_LIB

Q_SIGNALS:
    void pingAnswer(qint64 id, QString result);
    void loginAnswer(qint64 id, bool result);
    void activePremiumAnswer(qint64 id, bool result);
    void isPremiumAnswer(qint64 id, bool result);
    void setChartsAnswer(qint64 id, bool result);
    void unlockUserAnswer(qint64 id, bool result);
    void readUnlocksAnswer(qint64 id, QVariantList result);
    void contactAnswer(qint64 id, bool result);

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
            Q_EMIT pingAnswer(id, result.value<QString>());
        } else
        if(method == "login") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            Q_EMIT loginAnswer(id, result.value<bool>());
        } else
        if(method == "activePremium") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            Q_EMIT activePremiumAnswer(id, result.value<bool>());
        } else
        if(method == "isPremium") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            Q_EMIT isPremiumAnswer(id, result.value<bool>());
        } else
        if(method == "setCharts") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            Q_EMIT setChartsAnswer(id, result.value<bool>());
        } else
        if(method == "unlockUser") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            Q_EMIT unlockUserAnswer(id, result.value<bool>());
        } else
        if(method == "readUnlocks") {
            callBackCall<QVariantList>(id, result.value<QVariantList>(), error);
            _calls.remove(id);
            Q_EMIT readUnlocksAnswer(id, result.value<QVariantList>());
        } else
        if(method == "contact") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            Q_EMIT contactAnswer(id, result.value<bool>());
        } else
            Q_UNUSED(result);
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


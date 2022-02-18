#include "ubuntuplatform.h"

#include <stdlib.h>
#include <time.h>
#include <QDBusConnection>
#include <QDBusConnectionInterface>
#include <QDBusMetaType>
#include <QDBusReply>
#include <QDebug>
#include <QSettings>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QUuid>

UbuntuPlatform::UbuntuPlatform(WatchesManager *wm, QObject *parent) : QObject(parent)
{
    // initialize random seed
    std::srand (time(NULL));
    // Notifications
    m_notificationService = wm->notificationService();
    connect(m_notificationService, SIGNAL(ready()), this, SLOT(onNotificationServiceReady()));
    connect(wm, SIGNAL(disconnected()), this, SLOT(onDisconnected()));
    QDBusConnection::sessionBus().registerObject("/org/freedesktop/Notifications", this, QDBusConnection::ExportAllSlots);
    m_iface = new QDBusInterface("org.freedesktop.DBus", "/org/freedesktop/DBus", "org.freedesktop.DBus");
    m_iface->call("AddMatch", "interface='org.freedesktop.Notifications',member='Notify',type='method_call',eavesdrop='true'");

    //Media Service
    m_mediaService = wm->mediaService();
    connect(m_mediaService, SIGNAL(ready()), this, SLOT(onMediaServiceReady()));
    connect(m_mediaService, SIGNAL(play()), this, SLOT(onPlayMusicTitle()));
    connect(m_mediaService, SIGNAL(pause()), this, SLOT(onPauseMusicTitle()));
    connect(m_mediaService, SIGNAL(next()), this, SLOT(onNextMusicTitle()));
    connect(m_mediaService, SIGNAL(previous()), this, SLOT(onPreviousMusicTitle()));
}

UbuntuPlatform::~UbuntuPlatform()
{
}

QDBusInterface *UbuntuPlatform::interface() const
{
    return m_iface;
}

void UbuntuPlatform::onNotificationServiceReady()
{
    m_notificationServiceReady = true;
}

void UbuntuPlatform::onDisconnected()
{
    m_notificationServiceReady = false;
}

uint UbuntuPlatform::Notify(const QString &app_name, uint replaces_id, const QString &app_icon, const QString &summary, const QString &body, const QStringList &actions, const QVariantHash &hints, int expire_timeout)
{
    QStringList hiddenNotifications = {"indicator-sound", "indicator-network"};
    if (!hiddenNotifications.contains(app_name)) {
        if (hints.contains("x-canonical-secondary-icon") && hints.value("x-canonical-secondary-icon").toString() == "incoming-call") {
            qDebug() << __func__ << "Have a phone call notification. Ignoring it..." << app_name << app_icon;
        } else if(m_notificationServiceReady) {
            unsigned int randId = rand() % 100000 + 1;
            m_notificationService->insertNotification("", randId, encodeAppName(app_name), encodeIcon(app_name), summary, body, m_notificationService->getVibration());
        } else {
            qDebug() << __func__ << "Service not ready";
        }
    }
    setDelayedReply(true);
    return 0;
}

QString UbuntuPlatform::encodeIcon(const QString appName) const
{
    if(appName.contains("dekko"))
        return "ios-mail";
    else if(appName.contains("teleports"))
        return "ios-paper-plane";
	else if(appName.contains("indicator-datetime"))
		return "ios-alarm";
    else
        return "logo-tux";
}

QString UbuntuPlatform::encodeAppName(const QString appName) const
{
    if(appName.contains("dekko"))
        return "Dekko 2";
    else if(appName.contains("teleports"))
        return "TELEports";
    else if(appName.contains("fluffychat"))
        return "FluffyChat";
	else if(appName.contains("indicator-datetime"))
		return "Alarm";
    else
        return "unkown";
}

void UbuntuPlatform::onMediaServiceReady()
{
    setupMusicService();
}

void UbuntuPlatform::onPreviousMusicTitle()
{
    return sendMusicControlCommand("Previous");
}

void UbuntuPlatform::onNextMusicTitle()
{
    sendMusicControlCommand("Next");
}

void UbuntuPlatform::onPlayMusicTitle()
{
    sendMusicControlCommand("Play");
}

void UbuntuPlatform::onPauseMusicTitle()
{
    sendMusicControlCommand("Pause");
}

void UbuntuPlatform::sendMusicControlCommand(QString method)
{
    QDBusMessage call = QDBusMessage::createMethodCall(m_mprisService, "/org/mpris/MediaPlayer2", "org.mpris.MediaPlayer2.Player", method);
    QDBusError err = QDBusConnection::sessionBus().call(call);

    if (err.isValid()) {
        qDebug() << "Error calling mpris method on" << m_mprisService << ":" << err.message();
    }
}

void UbuntuPlatform::setupMusicService()
{
    if (!m_mprisService.isEmpty()) {
        disconnect(this, SLOT(onMprisPropertiesChanged(QString,QVariantMap,QStringList)));
    }

    QDBusConnectionInterface *iface = QDBusConnection::sessionBus().interface();
    const QStringList &services = iface->registeredServiceNames();
    foreach (QString service, services) {
        if (service.startsWith("org.mpris.MediaPlayer2.")) {
            m_mprisService = service;
            fetchPropertyAsync("Metadata");
            fetchPropertyAsync("PlaybackStatus");
            QDBusConnection::sessionBus().connect(m_mprisService, "/org/mpris/MediaPlayer2", "", "PropertiesChanged", this, SLOT(onMprisPropertiesChanged(QString,QVariantMap,QStringList)));
            break;
        }
    }
}

void UbuntuPlatform::fetchPropertyAsync(const QString &propertyName)
{
    if (!m_mprisService.isEmpty()) {
        QDBusMessage call = QDBusMessage::createMethodCall(m_mprisService, "/org/mpris/MediaPlayer2", "org.freedesktop.DBus.Properties", "Get");
        call << "org.mpris.MediaPlayer2.Player" << propertyName;
        QDBusPendingCall pcall = QDBusConnection::sessionBus().asyncCall(call);
        QDBusPendingCallWatcher *watcher = new QDBusPendingCallWatcher(pcall, this);
        connect(watcher, &QDBusPendingCallWatcher::finished, [this, propertyName](QDBusPendingCallWatcher *watcher) {
            watcher->deleteLater();
            QDBusReply<QDBusVariant> reply = watcher->reply();
            if (reply.isValid()) {
                propertyChanged(propertyName, reply.value().variant());
            } else {
                qDebug() << __func__ << reply.error().message();
            }
        });
    }
}

void UbuntuPlatform::onMprisPropertiesChanged(const QString &interface, const QVariantMap &changedProps, const QStringList &invalidatedProps)
{
    Q_UNUSED(interface)
    Q_UNUSED(invalidatedProps)

    if (changedProps.contains("PlaybackStatus")) {
        propertyChanged("PlaybackStatus", changedProps.value("PlaybackStatus"));
    }
    if (changedProps.contains("Metadata")) {
        propertyChanged("Metadata", changedProps.value("Metadata"));
    }
}

void UbuntuPlatform::propertyChanged(const QString &propertyName, const QVariant &value)
{
    if (propertyName == "Metadata") {
        QVariantMap curMetadata = qdbus_cast<QVariantMap>(value.value<QDBusArgument>());
        setArtist(curMetadata.value("xesam:artist").toString());
        setAlbum(curMetadata.value("xesam:album").toString());
        setTitle(curMetadata.value("xesam:title").toString());
    }
    if (propertyName == "PlaybackStatus") {
        setPlaying(value.toString());
    }
}

void UbuntuPlatform::setArtist(QString artist)
{
    if(artist != m_artist)
    {
        m_artist = artist;
        m_mediaService->setArtist(artist);
    }
}

void UbuntuPlatform::setTitle(QString title)
{
    if(title != m_title)
    {
        m_title = title;
        m_mediaService->setTitle(title);
    }
}

void UbuntuPlatform::setAlbum(QString album)
{
    if(album != m_album)
    {
        m_album = album;
        m_mediaService->setAlbum(album);
    }
}

void UbuntuPlatform::setPlaying(QString playingState)
{
    if(playingState != m_playingState)
    {
        m_playingState = playingState;
        m_mediaService->setPlaying(playingState.contains("Playing"));
    }
}

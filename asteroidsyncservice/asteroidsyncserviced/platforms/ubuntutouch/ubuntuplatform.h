#ifndef UBUNTUPLATFORM_H
#define UBUNTUPLATFORM_H

#include <QDBusContext>
#include <QDBusInterface>

#include "../../libasteroid/src/services/mediaservice.h"
#include "../../libasteroid/src/services/notificationservice.h"
#include "../../libasteroid/src/services/timeservice.h"
#include "../../watchesmanager.h"

class UbuntuPlatform : public QObject, public QDBusContext
{
    Q_OBJECT
    Q_CLASSINFO("D-Bus Interface", "org.freedesktop.Notifications")
    Q_PROPERTY(QDBusInterface* interface READ interface)

public:
    UbuntuPlatform(WatchesManager *wm, QObject *parent = 0);
    ~UbuntuPlatform();
    QDBusInterface* interface() const;

public slots:
    uint Notify(const QString &app_name, uint replaces_id, const QString &app_icon, const QString &summary, const QString &body, const QStringList &actions, const QVariantHash &hints, int expire_timeout);
    void onNotificationServiceReady();
    void onDisconnected();

private slots:
    void onMediaServiceReady();
    void onMprisPropertiesChanged(const QString &interface, const QVariantMap &changedProps, const QStringList &invalidatedProps);
    void onPreviousMusicTitle();
    void onNextMusicTitle();
    void onPlayMusicTitle();
    void onPauseMusicTitle();

private:
    QDBusInterface *m_iface;

    QString encodeIcon(QString appName) const;
    QString encodeAppName(QString appName) const;
    NotificationService *m_notificationService;
    bool m_notificationServiceReady = false;

    void setupMusicService();
    void fetchPropertyAsync(const QString &propertyName);
    void propertyChanged(const QString &propertyName, const QVariant &value);
    void sendMusicControlCommand(QString method);
    void setArtist(QString artist);
    void setTitle(QString title);
    void setAlbum(QString album);
    void setPlaying(QString playingState);
    MediaService *m_mediaService;
    QString m_mprisService;
    QString m_artist;
    QString m_title;
    QString m_album;
    QString m_playingState;
};

#endif // UBUNTUPLATFORM_H

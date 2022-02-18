/*
 *  libwatchfish - library with common functionality for SailfishOS smartwatch connector programs.
 *  Copyright (C) 2015 Javier S. Pedro <dev.git@javispedro.com>
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <QtCore/QDir>
#include <QtCore/QCryptographicHash>
#include <QDBusMessage>
#include <QDBusReply>

#include "musiccontroller.h"
#include "musiccontroller_p.h"

namespace watchfish
{

Q_LOGGING_CATEGORY(musicControllerCat, "watchfish-MusicController")

MusicControllerPrivate::MusicControllerPrivate(MusicController *q)
	: manager(new MprisManager(this)), q_ptr(q)
{
	connect(manager, &MprisManager::currentServiceChanged,
			this, &MusicControllerPrivate::handleCurrentServiceChanged);
	connect(manager, &MprisManager::playbackStatusChanged,
			this, &MusicControllerPrivate::handlePlaybackStatusChanged);
	connect(manager, &MprisManager::metadataChanged,
			this, &MusicControllerPrivate::handleMetadataChanged);
	connect(manager, &MprisManager::shuffleChanged,
			q, &MusicController::shuffleChanged);
	connect(manager, &MprisManager::loopStatusChanged,
			q, &MusicController::repeatChanged);
}

MusicControllerPrivate::~MusicControllerPrivate()
{
    if (_pulseBus != NULL) {
        qDebug() << "Disconnecting from PulseAudio P2P DBus";
        QDBusConnection::disconnectFromBus("org.PulseAudio1");
        delete(_pulseBus);
    }
}

QString MusicControllerPrivate::stripAlbumArtComponent(const QString& component)
{
	static QRegExp rsb("\\[.*\\]");
	static QRegExp rfb("{.*}");
	static QRegExp rrb("\\(.*\\)");
	static QRegExp stripB("^[()_{}[]!@#$^&*+=|\\\\/\"'?<>~`\\s\\t]*");
	static QRegExp stripE("[()_{}[]!@#$^&*+=|\\\\/\"'?<>~`\\s\\t]*$");
	QString s(component);

	if (s.isEmpty()) {
		return QString(" ");
	}

	s = s.replace(rsb, "");
	s = s.replace(rfb, "");
	s = s.replace(rrb, "");
	s = s.replace(stripB, "");
	s = s.replace(stripE, "");
	s = s.replace("  ", " ");
	s = s.replace("\t", " ");

	return s.toLower();
}

QString MusicControllerPrivate::findAlbumArt(const QString &artist, const QString &album)
{
	QDir dir(QDir::homePath() + "/.cache/media-art/");
	QByteArray first_hash = QCryptographicHash::hash(stripAlbumArtComponent(artist).toUtf8(),
													 QCryptographicHash::Md5).toHex();
	QByteArray second_hash = QCryptographicHash::hash(stripAlbumArtComponent(album).toUtf8(),
													  QCryptographicHash::Md5).toHex();
	QString file = QString("album-%1-%2.jpeg").arg(first_hash.constData()).arg(second_hash.constData());
	qCDebug(musicControllerCat()) << "checking for albumart in" << file;
	if (dir.exists(file)) {
		return dir.absoluteFilePath(file);
	}

	// Now try with an empty artist name
	first_hash = QCryptographicHash::hash(QString(" ").toUtf8(), QCryptographicHash::Md5).toHex();
	file = QString("album-%1-%2.jpeg").arg(first_hash.constData()).arg(second_hash.constData());
	qCDebug(musicControllerCat()) << "checking for albumart in" << file;
	if (dir.exists(file)) {
		return dir.absoluteFilePath(file);
	}

	return QString();
}

void MusicControllerPrivate::updateStatus()
{
	Q_Q(MusicController);
	QString service = manager->currentService();
	MusicController::Status newStatus;

	if (service.isEmpty()) {
		newStatus =  MusicController::StatusNoPlayer;
	} else {
		switch (manager->playbackStatus()) {
		case Mpris::Playing:
			newStatus = MusicController::StatusPlaying;
			break;
		case Mpris::Paused:
			newStatus = MusicController::StatusPaused;
			break;
		default:
			newStatus = MusicController::StatusStopped;
			break;
		}
	}

	if (newStatus != curStatus) {
		curStatus = newStatus;
		emit q->statusChanged();
	}
}

void MusicControllerPrivate::updateAlbumArt()
{
	Q_Q(MusicController);
	QString newAlbumArt = findAlbumArt(curArtist, curAlbum);
	if (newAlbumArt != curAlbumArt) {
		curAlbumArt = newAlbumArt;
		emit q->albumArtChanged();
	}
}

void MusicControllerPrivate::updateMetadata()
{
	Q_Q(MusicController);
	QVariantMap metadata = manager->metadata();
	bool checkAlbumArt = false;

	qCDebug(musicControllerCat()) << metadata;

	QString newArtist = metadata.value("xesam:artist").toString(),
			newAlbum = metadata.value("xesam:album").toString(),
			newTitle = metadata.value("xesam:title").toString();

	if (newArtist != curArtist) {
		curArtist = newArtist;
		checkAlbumArt = true;
		emit q->artistChanged();
	}

	if (newAlbum != curAlbum) {
		curAlbum = newAlbum;
		checkAlbumArt = true;
		emit q->albumChanged();
	}

	if (newTitle != curTitle) {
		curTitle = newTitle;
		emit q->titleChanged();
	}

	if (checkAlbumArt) {
		updateAlbumArt();
	}

	int newDuration = metadata.value("mpris:length").toULongLong() / 1000UL;
	if (newDuration != curDuration) {
		curDuration = newDuration;
		emit q->durationChanged();
	}

	emit q->metadataChanged();
}

void MusicControllerPrivate::handleCurrentServiceChanged()
{
	Q_Q(MusicController);
	qCDebug(musicControllerCat()) << manager->currentService();
	updateStatus();
	emit q->serviceChanged();
}

void MusicControllerPrivate::handlePlaybackStatusChanged()
{
	qCDebug(musicControllerCat()) << manager->playbackStatus();
	updateStatus();
}

void MusicControllerPrivate::handleMetadataChanged()
{
	updateMetadata();
}

MusicController::MusicController(QObject *parent)
    : QObject(parent), d_ptr(new MusicControllerPrivate(this))
{
}

MusicController::~MusicController()
{

	delete d_ptr;
}

void MusicControllerPrivate::connectPulseBus() {
    if (_pulseBus) {
        if (!_pulseBus->isConnected())
            delete(_pulseBus);
        else
            return;
    }
    QDBusMessage call = QDBusMessage::createMethodCall("org.PulseAudio1", "/org/pulseaudio/server_lookup1", "org.freedesktop.DBus.Properties", "Get" );
    call << "org.PulseAudio.ServerLookup1" << "Address";
    QDBusReply<QDBusVariant> lookupReply = QDBusConnection::sessionBus().call(call);
    if (lookupReply.isValid()) {
        qDebug() << "PulseAudio Bus address: " << lookupReply.value().variant().toString();
        _pulseBus = new QDBusConnection(QDBusConnection::connectToPeer(lookupReply.value().variant().toString(), "org.PulseAudio1"));
        if (_maxVolume == 0) {
            // Query max volume
            call = QDBusMessage::createMethodCall("com.Meego.MainVolume2", "/com/meego/mainvolume2",
                                                               "org.freedesktop.DBus.Properties", "Get");
            call << "com.Meego.MainVolume2" << "StepCount";
            QDBusReply<QDBusVariant> volumeMaxReply = _pulseBus->call(call);
            if (volumeMaxReply.isValid()) {
                _maxVolume = volumeMaxReply.value().variant().toUInt();
                qDebug() << "Max volume: " << _maxVolume;
            }
            else {
                qWarning() << "Could not read volume max, cannot adjust volume: " << volumeMaxReply.error().message();
            }
        }
    }
    else
        qDebug() << "Cannot connect to PulseAudio bus";
}

MusicController::Status MusicController::status() const
{
	Q_D(const MusicController);
	return d->curStatus;
}

QString MusicController::service() const
{
	Q_D(const MusicController);
	return d->manager->currentService();
}

QVariantMap MusicController::metadata() const
{
	Q_D(const MusicController);
	return d->manager->metadata();
}

QString MusicController::title() const
{
	Q_D(const MusicController);
	return d->curTitle;
}

QString MusicController::album() const
{
	Q_D(const MusicController);
	return d->curAlbum;
}

QString MusicController::artist() const
{
	Q_D(const MusicController);
	return d->curArtist;
}

QString MusicController::albumArt() const
{
	Q_D(const MusicController);
	return d->curAlbumArt;
}

int MusicController::duration() const
{
	Q_D(const MusicController);
	return d->curDuration;
}

MusicController::RepeatStatus MusicController::repeat() const
{
	Q_D(const MusicController);
	switch (d->manager->loopStatus()) {
	case Mpris::None:
	default:
		return RepeatNone;
	case Mpris::Track:
		return RepeatTrack;
	case Mpris::Playlist:
		return RepeatPlaylist;
	}
}

bool MusicController::shuffle() const
{
	Q_D(const MusicController);
	return d->manager->shuffle();
}

int MusicController::volume() const
{
    uint volume = -1;

    QDBusMessage call = QDBusMessage::createMethodCall("com.Meego.MainVolume2", "/com/meego/mainvolume2",
                                                   "org.freedesktop.DBus.Properties", "Get");
    call << "com.Meego.MainVolume2" << "CurrentStep";

    QDBusReply<QDBusVariant> volumeReply = d_ptr->_pulseBus->call(call);
    if (volumeReply.isValid()) {
        // Decide the new value for volume, taking limits into account
        volume = volumeReply.value().variant().toUInt();
    }
    return volume;
}

void MusicController::play()
{
	Q_D(MusicController);
	d->manager->play();
}

void MusicController::pause()
{
	Q_D(MusicController);
	d->manager->pause();
}

void MusicController::playPause()
{
	Q_D(MusicController);
	d->manager->playPause();
}

void MusicController::next()
{
	Q_D(MusicController);
	d->manager->next();
}

void MusicController::previous()
{
	Q_D(MusicController);
	d->manager->previous();
}

void MusicController::setVolume(const uint newVolume)
{
    qDebug() << "Setting volume: " << newVolume;
    d_ptr->connectPulseBus();
    QDBusMessage call = QDBusMessage::createMethodCall("com.Meego.MainVolume2", "/com/meego/mainvolume2",
                                          "org.freedesktop.DBus.Properties", "Set");
    call << "com.Meego.MainVolume2" << "CurrentStep" << QVariant::fromValue(QDBusVariant(newVolume));

    QDBusError err = d_ptr->_pulseBus->call(call);
    if (err.isValid()) {
        qWarning() << err.message();
    }
}

void MusicController::volumeUp()
{
    d_ptr->connectPulseBus();
    uint curVolume = this->volume();
    uint newVolume = curVolume + 1;
    if (newVolume >= d_ptr->_maxVolume) {
        qDebug() << "Cannot increase volume beyond maximum " << d_ptr->_maxVolume;
        return;
    }
    setVolume(newVolume);
}

void MusicController::volumeDown()
{
    d_ptr->connectPulseBus();
    uint curVolume = this->volume();
    if (curVolume == 0) {
        qDebug() << "Cannot decrease volume beyond 0";
        return;
    }
    uint newVolume = curVolume - 1;

    setVolume(newVolume);
}

}

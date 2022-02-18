/*
 * Copyright (C) 2018 - Florent Revest <revestflo@gmail.com>
 *               2016 - Andrew Branson <andrew.branson@jollamobile.com>
 *                      Ruslan N. Marchenko <me@ruff.mobi>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include "syncservice_plugin.h"

#include <QtQml>

#include "watches.h"
#include "watch.h"

#include "servicecontrol.h"

SyncServicePlugin::SyncServicePlugin(QObject *parent) : QQmlExtensionPlugin(parent)
{ }

void SyncServicePlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("org.asteroid.syncservice"));

    qmlRegisterUncreatableType<Watch>(uri, 1, 0, "Watch", "Get them from the model");
    qmlRegisterType<Watches>(uri, 1, 0, "Watches");
    qmlRegisterType<ServiceControl>(uri, 1, 0, "ServiceController");
}


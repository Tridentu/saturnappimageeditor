// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>

#pragma once

#include <QObject>
#include <filesystem>
#include <QUrl>
class QQuickWindow;

class App : public QObject
{
    Q_OBJECT

public:
    /// Save current window geometry
    Q_INVOKABLE void saveWindowGeometry(QQuickWindow *window, const QString &group = QStringLiteral("main")) const;
    Q_INVOKABLE void saveEntry(QString name,  QUrl appFile, QString comment, QString genericName, QString icon, bool startupNotify) const;

};

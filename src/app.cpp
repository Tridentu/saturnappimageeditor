// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>

#include "app.h"
#include <KSharedConfig>
#include <KWindowConfig>
#include <QQuickWindow>
#include <QDir>
#include <string>
#include <filesystem>

void App::saveWindowGeometry(QQuickWindow *window, const QString &group) const
{
    KConfig dataResource(QStringLiteral("data"), KConfig::SimpleConfig, QStandardPaths::AppDataLocation);
    KConfigGroup windowGroup(&dataResource, QStringLiteral("Window-") + group);
    KWindowConfig::saveWindowPosition(window, windowGroup);
    KWindowConfig::saveWindowSize(window, windowGroup);
    dataResource.sync();
}


void App::saveEntry(QString name, QUrl appFile, QString comment, QString genericName, QString icon, bool startupNotify) const
{
    QString appFileName;
    QString command;
    {
      std::filesystem::path filePath(appFile.path().toStdString());
      appFileName = QString::fromStdString(filePath.stem().string());
      command = QString::fromStdString(std::string("$HOME/Applications/") + filePath.stem().string() + filePath.extension().string());
    }
    QFile newDesktopFile(QDir::homePath().append("/Applications/.entries/").append(appFileName).append(".desktop"));
    if(newDesktopFile.open(QIODevice::ReadWrite)){
        QTextStream stream(&newDesktopFile);
        stream << "[Desktop Entry]" << Qt::endl;
        stream << "Name=" << name << Qt::endl;
        stream << "Comment=" << comment << Qt::endl;
        stream << "GenericName=" << genericName << Qt::endl;
        stream << "Icon=" << icon << Qt::endl;
        stream << "Exec=" << command << Qt::endl;
        stream << "Type=Application" << Qt::endl;
        stream << "StartupNotify=" << QString::fromStdString(startupNotify ? "true" : "false") << Qt::endl;
    }
    newDesktopFile.close();
}

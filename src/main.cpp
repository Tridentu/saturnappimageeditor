/*
    SPDX-License-Identifier: GPL-2.0-or-later
    SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>
*/

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QUrl>
#include <QtQml>

#include "about.h"
#include "app.h"
#include "version-saturnappimageeditor.h"
#include <KAboutData>
#include <KLocalizedContext>
#include <KLocalizedString>

#include "saturnappimageeditorconfig.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);
    QCoreApplication::setOrganizationName(QStringLiteral("Tridentu Group"));
    QCoreApplication::setApplicationName(QStringLiteral("saturnappimageeditor"));

    KAboutData aboutData(
                         // The program name used internally.
                         QStringLiteral("saturnappimageeditor"),
                         // A displayable program name string.
                         i18nc("@title", "Saturn AppImage Editor"),
                         // The program version string.
                         QStringLiteral(SATURNAPPIMAGEEDITOR_VERSION_STRING),
                         // Short description of what the app does.
                         i18n("An editor for .desktop entry files under \"~/Applications/.entries\"."),
                         // The license this code is released under.
                         KAboutLicense::GPL,
                         // Copyright Statement.
                         i18n("(c) 2022"));
    aboutData.addAuthor(i18nc("@info:credit", "Tridentu Group"));
    KAboutData::setApplicationData(aboutData);

    QQmlApplicationEngine engine;

    auto config = saturnappimageeditorConfig::self();

    qmlRegisterSingletonInstance("io.github.tridentu.saturnappimageeditor", 1, 0, "Config", config);

    AboutType about;
    qmlRegisterSingletonInstance("io.github.tridentu.saturnappimageeditor", 1, 0, "AboutType", &about);
    
    App application;
    qmlRegisterSingletonInstance("io.github.tridentu.saturnappimageeditor", 1, 0, "App", &application);

    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    return app.exec();
}

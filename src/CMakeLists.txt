# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>

add_executable(saturnappimageeditor
    main.cpp
    about.cpp
    app.cpp
    resources.qrc)

target_link_libraries(saturnappimageeditor
    Qt5::Core
    Qt5::Gui
    Qt5::Qml
    Qt5::Quick
    Qt5::QuickControls2
    Qt5::Svg
    KF5::I18n
    KF5::CoreAddons
    KF5::ConfigCore
    KF5::ConfigGui)

kconfig_add_kcfg_files(saturnappimageeditor GENERATE_MOC saturnappimageeditorconfig.kcfgc)
install(TARGETS saturnappimageeditor ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})

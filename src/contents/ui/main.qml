// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami
import QtQuick.Dialogs 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kquickcontrolsaddons 2.0 as KQuickAddons
import io.github.tridentu.saturnappimageeditor 1.0
Kirigami.ApplicationWindow {
    id: root
    Timer {
      id: timer   
    }
    function delay(delayTime, doFunc) {
                                    timer.interval = delayTime;
                                    timer.repeat = false;
                                    timer.triggered.connect(doFunc);
                                    timer.start();
                                    
    }
    title: i18n("saturnappimageeditor")

    minimumWidth: Kirigami.Units.gridUnit * 20
    minimumHeight: Kirigami.Units.gridUnit * 20

    onClosing: App.saveWindowGeometry(root)

    onWidthChanged: saveWindowGeometryTimer.restart()
    onHeightChanged: saveWindowGeometryTimer.restart()
    onXChanged: saveWindowGeometryTimer.restart()
    onYChanged: saveWindowGeometryTimer.restart()

    // This timer allows to batch update the window size change to reduce
    // the io load and also work around the fact that x/y/width/height are
    // changed when loading the page and overwrite the saved geometry from
    // the previous session.
    Timer {
        id: saveWindowGeometryTimer
        interval: 1000
        onTriggered: Controller.saveWindowGeometry(root)
    }


    globalDrawer: Kirigami.GlobalDrawer {
        title: i18n("Saturn AppImage Editor")
        titleIcon: "AppImage"
        isMenu: !root.isMobile
        actions: [
             Kirigami.Action {
                text: i18n("Save App Entry")
                icon.name: "filesave"
                onTriggered: {
                    App.saveEntry(desktopName.text, fileButton.appImageFile,  desktopComment.text, desktopGenericName.text, desktopIcon.icon.name,  desktopStartupNotify.checked);
                    savedMessage.visible = true
                    delay(2000, function(){
                       savedMessage.visible = false 
                    });
                }
            },
            Kirigami.Action {
                text: i18n("About Saturn AppImage Editor")
                icon.name: "help-about"
                onTriggered: pageStack.layers.push('qrc:About.qml')
            },
            Kirigami.Action {
                text: i18n("Quit")
                icon.name: "application-exit"
                onTriggered: Qt.quit()
            }
        ]
    }

    contextDrawer: Kirigami.ContextDrawer {
        id: contextDrawer
    }

    pageStack.initialPage: page

    Kirigami.Page {
        id: page

        Layout.fillWidth: true

        title: i18n("AppImage Editor")

        actions.main: Kirigami.Action {
                text: i18n("Save App Entry")
                icon.name: "filesave"
                onTriggered: {
                    App.saveEntry(desktopName.text, fileButton.appImageFile,  desktopComment.text, desktopGenericName.text, desktopIcon.icon.name,  desktopStartupNotify.checked);
                    savedMessage.visible = true
                    delay(2000, function(){
                       savedMessage.visible = false 
                    });
                }
        }

        Kirigami.FormLayout {
            width: page.width

            anchors.centerIn: parent
            
            Kirigami.InlineMessage {
                id: savedMessage
                Layout.fillWidth: true
                text: "Desktop Entry saved."
                visible: false
            }

            
            Controls.TextField {
                id: desktopName
                Kirigami.FormData.label: i18n("Application Name: ")
            }
            
            Controls.TextField {
                id: desktopComment
                Kirigami.FormData.label: i18n("Application Description: ")
            }
            
            Controls.TextField {
                id: desktopGenericName
                Kirigami.FormData.label: i18n("Application Name (Generic): ")
            }
            
            
            Controls.ToolButton {
                id: desktopIcon
                
                text: i18n("Choose Icon")
                    
                icon.name: "application-default-icon"
                
                KQuickAddons.IconDialog {
                    id: iconDialog
                    onIconNameChanged: desktopIcon.icon.name = iconName || desktopIcon.icon.name
                }

                onPressed: iconDialog.open()
                
                Kirigami.FormData.label: i18n("Application Icon: ")
            }
            
            Kirigami.Separator {
                
                Kirigami.FormData.label: i18n("Program Information")
                Kirigami.FormData.isSection: true
            }
            
            
            Controls.ToolButton {
                property url appImageFile
                id: fileButton
                icon.name: "AppImage"
                FileDialog {
                    id: appImageDialog
                    nameFilters: [
                        i18n("AppImages (%1)", "*.AppImage")
                    ]
                    onAccepted: fileButton.appImageFile = fileUrl
                }
                onPressed: appImageDialog.open()
                Kirigami.FormData.label: i18n("Application to Launch: ")
            }
            
            Controls.CheckBox {
                checked: false
                id: desktopStartupNotify
                Kirigami.FormData.label: i18n("Notify on Startup?: ")
            }
            
            
            
        }
    }
}

/**
 * inzaDownLoader
 *
 * Author : inza
 * GitHub : https://github.com/inza
 * Created: 2025
 *
 * A minimal downloader built with Qt / QML.
 * Focused on clarity, control and correctness.
 */

#include <windows.h>

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QQuickWindow>
#include <QWindow>

#include "app/application.h"
// http://proof.ovh.net/files/1Mb.dat
// D:/QTprojects/inza_downloader/downloads
// https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt
// https://peps.python.org/pep-0020.txt
// https://curl.se/windows/dl-8.8.0_1/curl-8.8.0_1-win64-mingw.zip
// https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip
// https://central.github.com/deployments/desktop/desktop/latest/win32
// https://nodejs.org/dist/v20.15.1/node-v20.15.1-x64.msi
// https://mirrors.tuna.tsinghua.edu.cn/fedora/releases/40/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-40-1.14.iso
// https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.6.0-amd64-netinst.iso
int main(int argc, char *argv[])
{

    Application app(argc, argv);
    // app.createOneWindow();
    app.run();

    // app.newDownload("https://speed.hetzner.de/10MB.bin", "D:\\QTprojects\\inza_downloader\\downloads");
}

#include "tools.h"

#include <QWindow>
#include <QQuickWindow>
#include <QQmlEngine>
#include <QQmlComponent>

#include <windows.h>
#include <dwmapi.h>

// add Windows shadow for window
void enableWinShadow(QWindow* w)
{
    if (!w) return;

    HWND hwnd = reinterpret_cast<HWND>(w->winId());
    if (!hwnd) return;

    DWMNCRENDERINGPOLICY policy = DWMNCRP_ENABLED;
    DwmSetWindowAttribute(
        hwnd,
        DWMWA_NCRENDERING_POLICY,
        &policy,
        sizeof(policy)
    );

    const MARGINS margins = {1, 1, 1, 1};
    DwmExtendFrameIntoClientArea(hwnd, &margins);
}

QQuickWindow* createNewWindow(QQmlEngine* engine)
{
    QQmlComponent comp(engine);
    comp.loadUrl(QUrl("qrc:/resources/qml/MainWindow.qml"));

    auto* window = qobject_cast<QQuickWindow*>(comp.create());
    enableWinShadow(window);
    return window;
}

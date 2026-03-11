#ifndef TOOLS_H
#define TOOLS_H

#include <QWindow>
#include <QQuickWindow>
#include <QQmlEngine>
#include <QQmlComponent>

#include <windows.h>
#include <dwmapi.h>

class QQmlEngine;
class QQuickWindow;

void enableWinShadow(QWindow* w);
QQuickWindow* createNewWindow(QQmlEngine* engine);

#endif // TOOLS_H

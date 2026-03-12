#ifndef APPLICATION_H
#define APPLICATION_H

#include <memory>
#include <qtmetamacros.h>
#include <qtypes.h>
#include <vector>
#include <QThread>

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>

#include "../core/AgentBackend.h"
#include "../core/download_controller.h"
#include "download_view_model.h"

class Application : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    
    QGuiApplication app_;
    QQmlApplicationEngine engine_;          // app 和 engine 是一对多
    std::vector<QQuickWindow*> windows_;  //保存了创建的窗口
    std::unique_ptr<DownloadController> controller_;

    AgentBackend* agent_backend_;
    QThread* agent_thread_;

    void addWindowShadow();

    void bindSlotsAndSignals(QObject*);                  // 绑定信号和槽

public:
    Application(int argc, char* argv[]);
    ~Application();

    void createOneWindow();

    void handleDownloadFinish();
    void handleDownloadStart(const QString& name, const QString& url, const QString& path, DownloadViewModel* view);
    void handleDownloadProgress(qint64 len, qint64 tot, DownloadViewModel* view);
    void handleDownloadError(const QString& errStr);


    void run();

public slots:
    void newDownload(const QString& name, const QString& url, const QString& path);
    void handleAgentMessageIn(const QString& msg);
signals:
    void downloadCreated(QObject* viewModel, const QString& name, const QString& url, const QString& path);
    void agentMessageIn(const QString& msg);
    void agentMessageReady(const QString& msg);
};

#endif // APPLICATION_H

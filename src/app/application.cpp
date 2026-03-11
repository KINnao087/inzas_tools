#include <qdebug.h>
#include <qlogging.h>
#include <qobject.h>
#include <QQmlContext>

#include "application.h"

#include "../core/AgentBackend.h"
#include "tools.h"
#include "download_controller.h"
#include "download_view_model.h"

// class Application : public QObject
// {
//     Q_OBJECT
//     QML_ELEMENT

//     QGuiApplication app_;
//     QQmlApplicationEngine engine_;          // app 和 engine 是一对多

//     std::vector<QQuickWindow*> windows_;  //保存了创建的窗口

//     std::unique_ptr<DownloadController> controller_;
//     std::unique_ptr<DownloadViewModel> view_;

//     void addWindowShadow();
// public:
//     Application(int argc, char* argv[]);
//     ~Application();

//     void createOneWindow();

//     void handleDownloadFinish();
//     void handleDownloadStart();
//     void handleDownloadProgress(qint64 len, qint64 tot);
//     void handleDownloadError(const QString& errStr);

//     void run();

// public slots:
//     void newDownload(const QString& url, const QString& path);
// signals:
//     void downloadCreated(QObject* viewModel, const QString& name);
// };

Application::Application(int argc, char* argv[])
     : app_(argc, argv), controller_(new DownloadController()), agent_backend_(new AgentBackend()) {
    auto& ctl = controller_;
    ctl->setOnError(std::bind(&Application::handleDownloadError, this, std::placeholders::_1));
    ctl->setOnFinished(std::bind(&Application::handleDownloadFinish, this));
    ctl->setOnProgress(std::bind(&Application::handleDownloadProgress, this, std::placeholders::_1, std::placeholders::_2, std::placeholders::_3));
    ctl->setOnStart(std::bind(&Application::handleDownloadStart, this, std::placeholders::_1, std::placeholders::_2, std::placeholders::_3, std::placeholders::_4));
}

Application::~Application() {
}

void Application::createOneWindow() {
    // qDebug() << "111";
    windows_.emplace_back(
        createNewWindow(&engine_)
    );
    enableWinShadow(windows_.back());
    // windows_.back()->show();
}

void Application::bindSlotsAndSignals(QObject* root)
{
    QObject::connect(
        root,
        SIGNAL(handleDownload(const QString&, const QString&, const QString&)),
        this,
        SLOT(newDownload(const QString&, const QString&, const QString&))
    );

    QObject* agentPage = root->findChild<QObject*>("agentPage");
    if (!agentPage) {qWarning() << "agentPage is null!"; return;}

    QObject::connect(
        agentPage,
        SIGNAL(sendMessage(const QString&)),
        this,
        SLOT(handleAgentMessageIn(const QString&))
    );


}

void Application::run() {
    engine_.rootContext()->setContextProperty("app", this);

    createOneWindow();
    QObject::connect(
        &engine_,
        &QQmlEngine::quit,
        &app_,
        &QGuiApplication::quit
    );
    if (windows_.size() && windows_[0] == nullptr || windows_.empty()) {
        qCritical() << "QML load failed";
        return;
    }

    QObject *root = windows_[0];
    bindSlotsAndSignals(root);
    

    app_.exec();
}

void Application::newDownload(const QString& name, const QString& url, const QString& path) {
    controller_->handleDownload(name, url, path);
}

void Application::handleDownloadFinish() {
    qDebug() << "Application: download finished!";
}

void Application::handleDownloadProgress(qint64 len, qint64 tot, DownloadViewModel* view) {
    qDebug() << "Application: received " << len << "/" << tot << "bytes";
    double p = double(len) / double(tot);
    view->setProgress(p);
}

void Application::handleDownloadStart(const QString& name, const QString& url, const QString& path, DownloadViewModel* view) {
    qDebug() << "Application: download start!";
    emit downloadCreated(view, name, url, path);
}

void Application::handleDownloadError(const QString& errStr) {
    qDebug() << "Application: download err: " << errStr;
}


void Application::handleAgentMessageIn(const QString& msg)
{
    qDebug() << "Application: message: " << msg;
    agent_backend_->onAgentMessageIn(msg);

    qDebug() << "Application: send message: " << msg;

    QString outMsg = agent_backend_->onAgentMessageOut();
    qDebug() << "Application: receive message: " << outMsg;
    emit agentMessageReady(outMsg);
}
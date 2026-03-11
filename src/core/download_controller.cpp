#include "download_controller.h"

#include <qlogging.h>
#include <QDebug>
#include <QObject>
#include <qnetworkaccessmanager.h>

#include "download_task.h"
#include "download_view_model.h"

DownloadController::DownloadController()
    : accessmanager_(new QNetworkAccessManager())
{}

void DownloadController::handleDownload(const QString& name, const QString& url, const QString& path) {
    qDebug() << "DownloadController: " << url << " " << path;
    
    DownloadTask* task = new DownloadTask(name, url, path);
    task->setOnError(std::bind(&DownloadController::onError, this, std::placeholders::_1));
    task->setOnFinished(std::bind(&DownloadController::onFinished, this));
    task->setOnProgress(std::bind(&DownloadController::onProgress, this, std::placeholders::_1, std::placeholders::_2, std::placeholders::_3));
    task->setOnStart(std::bind(&DownloadController::onStart, this, std::placeholders::_1, std::placeholders::_2, std::placeholders::_3, std::placeholders::_4));
    tasks_.emplace_back(task);

    task->start(accessmanager_.get());
}

void DownloadController::onStart(const QString& name, const QString& url, const QString& path, DownloadViewModel* view) {onstart_(name, url, path, view);}
void DownloadController::onFinished() {onfinished_();}
void DownloadController::onProgress(size_t len, size_t tot, DownloadViewModel* view) {onprogress_(len, tot, view);}
void DownloadController::onError(const QString& msg) {onerror_(msg);}

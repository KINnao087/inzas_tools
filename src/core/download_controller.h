#ifndef DOWNLOAD_CONTROLLER_H
#define DOWNLOAD_CONTROLLER_H

#include <QObject>
#include <QNetworkAccessManager>

#include "download_task.h"
#include "download_view_model.h"

class DownloadController
{
    // Q_OBJECT

    using StartCallback    = std::function<void(const QString&, const QString&, const QString&, DownloadViewModel*)>;
    using FinishedCallback = std::function<void()>;
    using ProgressCallback = std::function<void(qint64, qint64, DownloadViewModel*)>;
    using ErrorCallback    = std::function<void(const QString&)>;

    StartCallback onstart_;
    FinishedCallback onfinished_;
    ProgressCallback onprogress_;
    ErrorCallback onerror_;

    std::vector<DownloadTask*> tasks_;

    std::unique_ptr<QNetworkAccessManager> accessmanager_;
public:
    DownloadController();

    void setOnStart(const StartCallback& cb)    { onstart_ = cb; }
    void setOnFinished(const FinishedCallback& cb) { onfinished_ = cb; }
    void setOnProgress(const ProgressCallback& cb) { onprogress_ = cb; }
    void setOnError(const ErrorCallback& cb)    { onerror_ = cb; }

    void onStart(const QString& name, const QString& url, const QString& path, DownloadViewModel* view);
    void onFinished();
    void onProgress(size_t len, size_t tot, DownloadViewModel* view);
    void onError(const QString& msg);

    void handleDownload(const QString& name, const QString& url, const QString& path);
// public slots: 
};

#endif // DOWNLOAD_CONTROLLER_H

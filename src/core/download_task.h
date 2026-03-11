#ifndef DOWNLOAD_TASK_H
#define DOWNLOAD_TASK_H

#include <QString>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QFile>
#include <qcontainerfwd.h>

#include "download_view_model.h"

class DownloadTask
{
    using StartCallback    = std::function<void(const QString&, const QString&, const QString&, DownloadViewModel*)>;
    using FinishedCallback = std::function<void()>;
    using ProgressCallback = std::function<void(qint64, qint64, DownloadViewModel*)>;
    using ErrorCallback    = std::function<void(const QString&)>;

    QString name_;                              // 任务名称
    QString url_;                               // 下载连接
    QString path_;                              // 下载路径
    QFile file_;                                
    QNetworkReply* reply_ = nullptr;          
    std::unique_ptr<DownloadViewModel> view_;   // 每一个downloadmission都必须对应一个downloadview

    StartCallback onstart_;
    FinishedCallback onfinished_;
    ProgressCallback onprogress_;
    ErrorCallback onerror_;
public:
    DownloadTask(const QString& name = "", const QString& url = "", const QString& path = "");
    void setUrl(const QString& url) {url_ = url;}
    void setPath(const QString& path) {path_ = path;}

    QString url() const {return url_;}
    QString path() const {return path_;}

    void setOnStart(const StartCallback& cb)    { onstart_ = cb; }
    void setOnFinished(const FinishedCallback& cb) { onfinished_ = cb; }
    void setOnProgress(const ProgressCallback& cb) { onprogress_ = cb; }
    void setOnError(const ErrorCallback& cb)    { onerror_ = cb; }

    void start(QNetworkAccessManager* nam);
};

#endif // DOWNLOAD_TASK_H

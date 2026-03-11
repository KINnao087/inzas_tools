#include "download_task.h"
#include "download_view_model.h"

#include <QNetworkRequest>
#include <QFileInfo>
#include <QUrl>
#include <QDir>
#include <qdebug.h>
#include <qnetworkreply.h>
#include <qurl.h>

// class DownloadTask
// {
//     QString url_;
//     QString path_;
// public:
//     DownloadTask(QString url = "", QString path = "");
//     void setUrl();
//     void setPath();

//     QString url();
//     QString path();

//     void start();
// };

DownloadTask::DownloadTask(const QString& name, const QString& url, const QString& path)
     : url_(url), path_(path), view_(new DownloadViewModel()), name_(name) {}

void inline getTrueName(QString& name, const QUrl& qurl) {
    if (name == "") {
        QString fullname = QFileInfo(qurl.path()).fileName();
        name = fullname;
    } else {
        QString suffix = QFileInfo(qurl.path()).suffix();
        name += "." + suffix;
    }
}

QNetworkReply* getReply(const QUrl& qurl, QNetworkAccessManager* nam) {
    QNetworkRequest request(qurl);
    request.setAttribute(QNetworkRequest::RedirectPolicyAttribute,
                     QNetworkRequest::NoLessSafeRedirectPolicy);
    return nam->get(request);
}

void DownloadTask::start(QNetworkAccessManager* nam) {
    if (reply_) {
        // 已经在下载，防止重复 start
        return;
    }

    // 下载链接不存在
    QUrl qurl(url_);
    if (!qurl.isValid()) {
        if (onerror_) onerror_("invalid url");
        return;
    }

    // 获得文件名
    getTrueName(name_, qurl);

    QDir dir(path_);
    path_ = dir.filePath(name_);
    qDebug() << path_;
    file_.setFileName(path_);
    if (!file_.open(QIODevice::WriteOnly | QIODevice::Truncate)) {
        if (onerror_) onerror_(file_.errorString());
        return;
    }

    // 获得reply
    reply_ = getReply(qurl, nam);
    int status = reply_->attribute(
        QNetworkRequest::HttpStatusCodeAttribute
    ).toInt();
    // 如果状态码是301 / 302 就重新来一次
    if (status == 301 || status == 302) {
        QUrl real = reply_->header(QNetworkRequest::LocationHeader).toUrl();
        reply_ = getReply(qurl, nam);
    }

    // 一路回调并通知qml
    if (onstart_) onstart_(name_, url_, path_, view_.get());
    // readyRead：写文件
    QObject::connect(reply_, &QNetworkReply::readyRead,
        [this]() {
            file_.write(reply_->readAll());
        }
    );

    // progress：转成回调
    QObject::connect(reply_, &QNetworkReply::downloadProgress,
        [this](qint64 recv, qint64 total) {
            if (onprogress_) onprogress_(recv, total, view_.get());
        }
    );

    // finished：http请求结束，但不代表下载终止
    QObject::connect(reply_, &QNetworkReply::finished,
    [&]() {
        if (!reply_) return;

        // 先拿信息再 deleteLater
        const bool ok = (reply_->error() == QNetworkReply::NoError);
        const QString err = reply_->errorString();
        const int status = reply_->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        // qDebug() << "status =" << status << "final url =" << reply_->url();

        file_.flush();
        file_.close();

        reply_->deleteLater();
        reply_ = nullptr;
        if (status == 301 || status == 302) {
            reply_ = getReply(qurl, nam);
        }
        if (status == 500 )

        if (ok) {
            if (onfinished_) onfinished_();
        } else {
            // 有些站会返回 200 的 html“提示页”，你需要自己再加 Content-Type/大小校验（后面做分块时一起加）
            if (onerror_) onerror_(err.isEmpty() ? QString("http failed, status=%1").arg(status) : err);
        }
    });
    

}

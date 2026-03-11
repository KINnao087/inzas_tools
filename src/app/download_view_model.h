#ifndef DOWNLOAD_VIEW_MODEL_H
#define DOWNLOAD_VIEW_MODEL_H

#include <QObject>
#include <qqmlintegration.h>

class DownloadViewModel : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(double progress READ progress NOTIFY progressChanged)

    double progress_;
public:
    DownloadViewModel(QObject* parent = nullptr);

    double progress() const {return progress_;}
    void setProgress(double p);
signals: 
    void progressChanged(double p);
};

#endif // DOWNLOAD_VIEW_MODEL_H

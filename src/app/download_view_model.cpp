#include "download_view_model.h"

#include <QDebug>

DownloadViewModel::DownloadViewModel(QObject* parent) : QObject(parent) {}

void DownloadViewModel::setProgress(double p) {
    p = p < 0 ? 0 : p;
    p = p > 1 ? 1 : p;

    // qDebug() << "progress val " << p;

    progress_ = p;
    emit progressChanged(p);
}
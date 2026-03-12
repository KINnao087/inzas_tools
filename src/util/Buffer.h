//
// Created by 35352 on 2026/3/12.
//

#ifndef INZA_DOWNLOADER_BUFFER_H
#define INZA_DOWNLOADER_BUFFER_H

#include <QByteArray>
#include <QList>

class Buffer
{
public:
    void append(const QByteArray& chunk);
    QList<QByteArray> takeMessages();
    bool empty() const;
    void clear();

private:
    QByteArray data_;
};


#endif //INZA_DOWNLOADER_BUFFER_H

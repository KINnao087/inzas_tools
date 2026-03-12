//
// Created by 35352 on 2026/3/12.
//

#include "Buffer.h"

void Buffer::append(const QByteArray& chunk)
{
    data_.append(chunk);
}

QList<QByteArray> Buffer::takeMessages()
{
    QList<QByteArray> messages;

    while (true) {
        const qsizetype newline_pos = data_.indexOf('\n');
        if (newline_pos < 0) {
            break;
        }

        messages.append(data_.left(newline_pos));
        data_.remove(0, newline_pos + 1);
    }

    return messages;
}

bool Buffer::empty() const
{
    return data_.isEmpty();
}

void Buffer::clear()
{
    data_.clear();
}

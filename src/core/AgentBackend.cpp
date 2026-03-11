//
// Created by 35352 on 2026/3/10.
//

#include <QDebug>

#include "AgentBackend.h"
#include "json_tools.h"

// #ifndef INZA_DOWNLOADER_AGENT_BACKEND_H
// #define INZA_DOWNLOADER_AGENT_BACKEND_H
// #include <QObject>
//
//
// class AgentBackend : public QObject
// {
//     Q_OBJECT
// public:
//     explicit AgentBackend(QObject *parent = nullptr) : QObject(parent) {};
//
// public slots:
//     void onMessageReceived(QByteArray message);
// };

AgentBackend::AgentBackend(const QString& ip, short port) : socket_(new QTcpSocket())
{
    socket_->connectToHost(ip, port);
}

void AgentBackend::onAgentMessageIn(const QString& msg)
{
    qDebug() << "received message:" << msg;
    //TODO: 将信息发送给agent
    socket_->connectToHost("127.0.0.1", 5050);

    if (!socket_->waitForConnected(1000))
    {
        qDebug() << "waiting for host connection timeout";
        return;
    }

    const QByteArray payload = messageToAgentJson(msg).toUtf8();
    qDebug() << "send json:" << payload;
    socket_->write(payload);
}

QString AgentBackend::onAgentMessageOut()
{
    //TODO: 从agent获取信息
    if (!socket_->waitForReadyRead(60000)) {
        qDebug() << "read timeout:" << socket_->errorString();
        return QString();
    }

    QString received = socket_->readAll();

    qDebug() << "received message:" << received;

    return QString(jsonValueByKey(received, "reply"));
    // qDebug() << "send message:" << msg;

}

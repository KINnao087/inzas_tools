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

AgentBackend::AgentBackend(const QString& ip, quint16 port, QObject *parent) : ip_(ip), port_(port), QObject(parent)
{
}

AgentBackend::~AgentBackend()
{
}

void AgentBackend::start()
{
    qDebug() << "AgentBackend::start";
    socket_ = new QTcpSocket(this);

    connect(socket_, &QTcpSocket::connected, this, &AgentBackend::onConnected);
    connect(socket_, &QTcpSocket::readyRead, this, &AgentBackend::onReadyRead);
    connect(socket_, &QAbstractSocket::errorOccurred, this, &AgentBackend::onSocketError);

    socket_->connectToHost(ip_, port_);
}

void AgentBackend::sendMessage(const QString& msg)
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

void AgentBackend::onConnected()
{
    qDebug() << "Agent connected:" << ip_ << port_;
}

void AgentBackend::onReadyRead()
{
    buffer_.append(socket_->readAll());

    const QList<QByteArray> messages = buffer_.takeMessages();
    for (const QByteArray& message : messages) {
        emit messageReady(jsonValueByKey(QString::fromUtf8(message), "reply"));
    }
}

void AgentBackend::onSocketError(QAbstractSocket::SocketError)
{
    qDebug() << "socketError:" << socket_->errorString();

    emit errorOccurred(socket_->errorString());
}

//
// Created by 35352 on 2026/3/10.
//

#ifndef INZA_DOWNLOADER_AGENT_BACKEND_H
#define INZA_DOWNLOADER_AGENT_BACKEND_H

#include <memory>

#include <QString>
#include <QTcpSocket>
#include <QObject>

#include "Buffer.h"

class AgentBackend : public QObject
{
    Q_OBJECT
    QString ip_;
    quint16 port_;
    QTcpSocket* socket_ = nullptr;
    Buffer buffer_;
public:
    explicit AgentBackend(const QString& ip = "127.0.0.1", quint16 port = 5050, QObject *parent = nullptr);
    ~AgentBackend();

public slots:
    void start();
    void sendMessage(const QString& msgIn);    // 将在这里将消息发送给PythonAgent

signals:
    void messageReady(const QString& msg);
    void errorOccurred(const QString& err);

private slots:
    void onConnected();
    void onReadyRead();
    void onSocketError(QAbstractSocket::SocketError);

};


#endif //INZA_DOWNLOADER_AGENT_BACKEND_H

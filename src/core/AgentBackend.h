//
// Created by 35352 on 2026/3/10.
//

#ifndef INZA_DOWNLOADER_AGENT_BACKEND_H
#define INZA_DOWNLOADER_AGENT_BACKEND_H

#include <memory>

#include <QString>
#include <QTcpSocket>

class AgentBackend
{
    std::unique_ptr<QTcpSocket> socket_;

public:
    explicit AgentBackend(const QString& ip = "127.0.0.1", short port = 5050);
    void onAgentMessageIn(const QString& msgIn);    // 将在这里将消息发送给PythonAgent
    QString onAgentMessageOut();
};


#endif //INZA_DOWNLOADER_AGENT_BACKEND_H

//
// Created by 35352 on 2026/3/11.
//

#include "json_tools.h"

#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonParseError>
#include <QJsonValue>

QString messageToAgentJson(const QString& msg)
{
    QJsonObject payload{
        {"action", "chat"},
        {"session_id", "demo"},
        {"task", msg},
        {"max_steps", 12},
        {"stream", false}
    };

    return QString::fromUtf8(
        QJsonDocument(payload).toJson(QJsonDocument::Compact)
    ) + "\n";
}

QString jsonValueByKey(const QString& json, const QString& key)
{
    QJsonParseError error;
    const QByteArray normalized = json.trimmed().toUtf8();
    const QJsonDocument doc = QJsonDocument::fromJson(normalized, &error);
    if (error.error != QJsonParseError::NoError || !doc.isObject()) {
        return QString();
    }

    const QJsonObject obj = doc.object();
    if (!obj.contains(key)) {
        return QString();
    }

    const QJsonValue value = obj.value(key);
    if (value.isString()) {
        return value.toString();
    }
    if (value.isDouble()) {
        return QString::number(value.toDouble());
    }
    if (value.isBool()) {
        return value.toBool() ? "true" : "false";
    }
    if (value.isNull() || value.isUndefined()) {
        return QString();
    }
    if (value.isObject()) {
        return QString::fromUtf8(
            QJsonDocument(value.toObject()).toJson(QJsonDocument::Compact)
        );
    }
    if (value.isArray()) {
        return QString::fromUtf8(
            QJsonDocument(value.toArray()).toJson(QJsonDocument::Compact)
        );
    }

    return QString();
}

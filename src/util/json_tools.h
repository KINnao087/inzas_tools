//
// Created by 35352 on 2026/3/11.
//

#ifndef INZA_DOWNLOADER_MSGTOJSON_H
#define INZA_DOWNLOADER_MSGTOJSON_H

#include <QString>

QString messageToAgentJson(const QString& msg);
QString jsonValueByKey(const QString& json, const QString& key);

#endif //INZA_DOWNLOADER_MSGTOJSON_H

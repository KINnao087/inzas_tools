cmake_minimum_required(VERSION 3.16)

project(inza_downloader)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Gui Core Qml QuickEffects)
find_package(Qt6 REQUIRED COMPONENTS Core)
find_package(Qt6 REQUIRED COMPONENTS Core)

set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOMOC ON)

add_executable(${PROJECT_NAME}
    ./src/main.cpp
    src.qrc
    ./src/util/tools.h ./src/util/tools.cpp
    ./src/app/application.h ./src/app/application.cpp
    ./src/core/download_controller.h ./src/core/download_controller.cpp
    src/core/download_task.h src/core/download_task.cpp
    src/app/download_view_model.h src/app/download_view_model.cpp
        src/core/AgentBackend.cpp
        src/core/AgentBackend.h
        src/util/json_tools.cpp
        src/util/json_tools.h
)

target_link_libraries(
    inza_downloader 
    PRIVATE
        Qt6::Core
        Qt6::Gui
        Qt6::Qml
        Qt6::Quick
        Qt6::QuickEffects
        Qt6::Network
        dwmapi
)
target_include_directories(inza_downloader PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src/app
    ${CMAKE_CURRENT_SOURCE_DIR}/src/core
    ${CMAKE_CURRENT_SOURCE_DIR}/src/util
)
target_link_libraries(inza_downloader PRIVATE Qt6::Core)
target_link_libraries(inza_downloader PRIVATE Qt6::Core)

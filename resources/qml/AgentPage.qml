import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Item {
    id: agentPage
    // AgentPage 作为 StackLayout 的一个整页内容项，需要铺满主内容区
    Layout.fillWidth: true
    Layout.fillHeight: true
    // 裁掉超出页面边界的装饰元素，避免视觉上溢出到外部
    clip: true

    signal sendMessage(string message)
    signal clearConversation()

    property string agentName: "Inza Agent"
    property string agentSubtitle: "Manage downloads, inspect links, and prepare task actions"

    function appendUserMessage(message) {
        if (message.length === 0) {
            return;
        }
        conversationModel.append({
            role: "user",
            author: "You",
            content: message,
            timeText: Qt.formatTime(new Date(), "hh:mm")
        });
    }

    Connections {
        target: app
        function onAgentMessageReady(message) {
            appendAgentMessage(message)
        }
    }

    function appendAgentMessage(message) {
        if (message.length === 0) {
            return;
        }
        conversationModel.append({
            role: "assistant",
            author: agentName,
            content: message,
            timeText: Qt.formatTime(new Date(), "hh:mm")
        });
    }

    function submitCurrentMessage() {
        var message = promptField.text.trim();
        if (message.length === 0) {
            return;
        }

        appendUserMessage(message);
        sendMessage(message);
        promptField.text = "";

        // if (conversationModel.count < 5) {
        //     appendAgentMessage("Message received. Connect the `sendMessage` signal to your backend and replace this placeholder reply.");
        // }

        messageList.positionViewAtEnd();
    }

    ListModel {
        id: conversationModel

        // 初始欢迎消息，对应界面中间“Conversation”区域里的前两条气泡
        ListElement {
            role: "assistant"
            author: "Inza Agent"
            content: "Welcome to the agent workspace. Use this page to send prompts, view status, and later connect real tools."
            timeText: "09:30"
        }
        ListElement {
            role: "assistant"
            author: "Inza Agent"
            content: "Start with a minimal backend handler that returns plain text, then extend it with real actions."
            timeText: "09:31"
        }
    }

    Rectangle {
        // 整个 Agent 页的背景层，对应右侧主内容区域的灰色渐变底
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#f4f4f4" }
            GradientStop { position: 0.45; color: "#ededed" }
            GradientStop { position: 1.0; color: "#e5e5e5" }
        }
    }

    Rectangle {
        // 右上角装饰圆，对应页面右上区域的半透明浅色背景图形
        width: 380
        height: 380
        radius: width / 2
        color: "#ffffff"
        opacity: 0.26
        x: parent.width - width * 0.72
        y: -height * 0.38
    }

    Rectangle {
        // 左下角装饰圆，对应页面左下区域的浅灰色背景图形
        width: 260
        height: 260
        radius: width / 2
        color: "#d8d8d8"
        opacity: 0.28
        x: 90
        y: parent.height - height * 0.42
    }

    RowLayout {
        // 页面主体横向分栏：左边是聊天区，右边是状态/说明侧栏
        anchors.fill: parent
        anchors.margins: 32
        spacing: 24

        Rectangle {
            // 左侧主卡片，对应界面中占比最大的聊天工作区
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 28
            color: "#fafafa"
            border.color: "#d8d8d8"
            border.width: 1

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: "#22000000"
                shadowBlur: 0.7
                shadowVerticalOffset: 6
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 28
                spacing: 22

                Rectangle {
                    // 顶部欢迎横幅，对应聊天区最上面的深色标题区域
                    Layout.fillWidth: true
                    Layout.preferredHeight: 128
                    radius: 24
                    color: "#141414"

                    Rectangle {
                        // 欢迎横幅内部的装饰圆，对应标题栏右上角的灰色圆形光斑
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.rightMargin: -22
                        anchors.topMargin: -30
                        width: 170
                        height: 170
                        radius: width / 2
                        color: "#5a5a5a"
                        opacity: 0.22
                    }

                    Column {
                        // 欢迎横幅左侧文本区，对应 “Inza Agent” 和副标题所在位置
                        anchors.left: parent.left
                        anchors.leftMargin: 24
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 10

                        Rectangle {
                            // 状态标签，对应标题栏左上角 “AGENT ONLINE” 胶囊标签
                            width: 112
                            height: 32
                            radius: 16
                            color: "#2a2a2a"

                            Text {
                                anchors.centerIn: parent
                                text: "AGENT ONLINE"
                                color: "#f1f1f1"
                                font.pixelSize: 12
                                font.bold: true
                                font.letterSpacing: 1.2
                            }
                        }

                        Text {
                            text: agentName
                            color: "#ffffff"
                            font.pixelSize: 28
                            font.bold: true
                        }

                        Text {
                            text: agentSubtitle
                            color: "#bdbdbd"
                            font.pixelSize: 14
                        }
                    }
                }

                Rectangle {
                    // 会话内容卡片，对应中间大面积的聊天消息区域
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 24
                    color: "#f2f2f2"
                    border.color: "#dddddd"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 18
                        spacing: 14

                        RowLayout {
                            // 会话区顶部栏，对应 “Conversation” 标题和右侧消息数量
                            Layout.fillWidth: true

                            Text {
                                text: "Conversation"
                                color: "#1c1c1c"
                                font.pixelSize: 20
                                font.bold: true
                            }

                            Item {
                                Layout.fillWidth: true
                            }

                            Rectangle {
                                Layout.preferredWidth: 92
                                Layout.preferredHeight: 34
                                radius: 17
                                color: "#e7e7e7"

                                Text {
                                    anchors.centerIn: parent
                                    text: conversationModel.count + " msgs"
                                    color: "#555555"
                                    font.pixelSize: 12
                                    font.bold: true
                                }
                            }
                        }

                        ListView {
                            id: messageList
                            // 消息列表，对应中间滚动显示的聊天气泡区域
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: 14
                            clip: true
                            model: conversationModel
                            boundsBehavior: Flickable.StopAtBounds

                            delegate: Item {
                                // 单条消息容器，对应一条用户/Agent 聊天气泡
                                width: messageList.width
                                height: bubble.implicitHeight + 6

                                Rectangle {
                                    id: bubble
                                    // 消息气泡本体：用户消息右对齐，Agent 消息左对齐
                                    width: Math.min(parent.width * 0.78, messageContent.implicitWidth + 34)
                                    implicitHeight: contentColumn.implicitHeight + 24
                                    radius: 20
                                    anchors.right: role === "user" ? parent.right : undefined
                                    anchors.left: role === "assistant" ? parent.left : undefined
                                    color: role === "user" ? "#1c1c1c" : "#ffffff"
                                    border.color: role === "user" ? "#1c1c1c" : "#d8d8d8"
                                    border.width: 1

                                    Column {
                                        // 气泡内部内容：上方作者和时间，下方正文
                                        id: contentColumn
                                        anchors.fill: parent
                                        anchors.margins: 14
                                        spacing: 8

                                        Row {
                                            spacing: 8

                                            Text {
                                                text: author
                                                color: role === "user" ? "#f5f5f5" : "#1d1d1d"
                                                font.pixelSize: 13
                                                font.bold: true
                                            }

                                            Text {
                                                text: timeText
                                                color: role === "user" ? "#ababab" : "#7d7d7d"
                                                font.pixelSize: 12
                                            }
                                        }

                                        Text {
                                            id: messageContent
                                            width: bubble.width - 28
                                            text: content
                                            wrapMode: Text.Wrap
                                            color: role === "user" ? "#efefef" : "#333333"
                                            font.pixelSize: 14
                                            lineHeight: 1.4
                                        }
                                    }
                                }
                            }
                        }

                        Rectangle {
                            // 底部输入区，对应页面最下方的文本输入框和发送按钮区域
                            Layout.fillWidth: true
                            Layout.preferredHeight: 116
                            radius: 22
                            color: "#fbfbfb"
                            border.color: promptField.activeFocus ? "#5d5d5d" : "#d4d4d4"
                            border.width: 1

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 12

                                TextArea {
                                    id: promptField
                                    // 输入框主体，对应底部大文本输入区域
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    placeholderText: "Ask the agent to inspect a link, explain a failure, or draft a task summary."
                                    wrapMode: TextEdit.Wrap
                                    selectByMouse: true
                                    font.pixelSize: 14
                                    color: "#222222"
                                    background: null

                                    Keys.onReturnPressed: function(event) {
                                        if (!(event.modifiers & Qt.ShiftModifier)) {
                                            event.accepted = true;
                                            agentPage.submitCurrentMessage();
                                        }
                                    }
                                }

                                RowLayout {
                                    // 输入区底部操作栏，对应提示文案、Clear 按钮、Send 按钮
                                    Layout.fillWidth: true

                                    Text {
                                        text: "Enter to send, Shift+Enter for newline"
                                        color: "#707070"
                                        font.pixelSize: 12
                                    }

                                    Item {
                                        Layout.fillWidth: true
                                    }

                                    Button {
                                        text: "Clear"
                                        flat: true

                                        onClicked: {
                                            conversationModel.clear();
                                            agentPage.clearConversation();
                                        }
                                    }

                                    Button {
                                        text: "Send"
                                        enabled: promptField.text.trim().length > 0

                                        background: Rectangle {
                                            radius: 18
                                            color: parent.enabled ? "#222222" : "#9e9e9e"
                                        }

                                        contentItem: Text {
                                            text: parent.text
                                            color: "#ffffff"
                                            font.pixelSize: 14
                                            font.bold: true
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                        }

                                        onClicked: agentPage.submitCurrentMessage()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            // 右侧信息侧栏，对应 Workspace、Status 以及几张说明卡片
            Layout.preferredWidth: 290
            Layout.fillHeight: true
            radius: 28
            color: "#fafafa"
            border.color: "#d8d8d8"
            border.width: 1

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: "#18000000"
                shadowBlur: 0.7
                shadowVerticalOffset: 6
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 18

                Text {
                    // 右侧栏标题，对应右侧顶部 “Workspace”
                    text: "Workspace"
                    color: "#171717"
                    font.pixelSize: 22
                    font.bold: true
                }

                Rectangle {
                    // 状态卡片，对应右侧第一张 “Status / Connected” 信息卡
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120
                    radius: 22
                    color: "#f0f0f0"
                    border.color: "#dddddd"
                    border.width: 1

                    Column {
                        anchors.fill: parent
                        anchors.margins: 18
                        spacing: 10

                        Text {
                            text: "Status"
                            color: "#666666"
                            font.pixelSize: 13
                        }

                        Text {
                            text: "Connected"
                            color: "#1d1d1d"
                            font.pixelSize: 26
                            font.bold: true
                        }

                        Text {
                            text: "Use this card for backend state, model name, and response timing."
                            color: "#777777"
                            font.pixelSize: 13
                            wrapMode: Text.Wrap
                            width: parent.width
                        }
                    }
                }

                Repeater {
                    // 说明卡片列表，对应右侧下方三张功能说明卡片
                    model: [
                        {
                            "title": "Suggested actions",
                            "body": "Use this area for link inspection, task naming help, and log explanation results."
                        },
                        {
                            "title": "Backend hook",
                            "body": "Connect `sendMessage(message)` to a C++ or Python backend and append the returned text here."
                        },
                        {
                            "title": "Next step",
                            "body": "Add a busy state and streaming output panel next to make the interaction feel complete."
                        }
                    ]

                    delegate: Rectangle {
                        // 单张说明卡，对应右侧每一块矩形介绍区域
                        Layout.fillWidth: true
                        Layout.preferredHeight: 126
                        radius: 20
                        color: "#f8f8f8"
                        border.color: "#dfdfdf"
                        border.width: 1

                        Column {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 10

                            Text {
                                text: modelData.title
                                color: "#202020"
                                font.pixelSize: 16
                                font.bold: true
                            }

                            Text {
                                text: modelData.body
                                color: "#6c6c6c"
                                font.pixelSize: 13
                                width: parent.width
                                wrapMode: Text.Wrap
                                lineHeight: 1.35
                            }
                        }
                    }
                }
            }
        }
    }
}

import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Popup {
    id: addPopup

    signal submit(string name, string url, string path)

    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    width: 420
    height: 280

    // 居中显示
    anchors.centerIn: Overlay.overlay

    background: Rectangle {
        radius: 10
        color: "white"


        // 轻阴影
        MultiEffect {
            anchors.fill: background
            source: background

            shadowEnabled: true
            shadowColor: "#40000000"
            shadowBlur: 0.5
            shadowVerticalOffset: 4
        }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16

        // 标题

        Text {
            text: "新增下载任务"
            font.pixelSize: 18
            font.bold: true
            color: "#111"
        }

        //名字
        InputText {
            id: nameField
            placeholderText: "请输入名字"
        }
        // 下载链接
        InputText {
            id: urlField
            placeholderText: "请输入下载链接"
        }
        // 保存路径
        InputText {
            id: pathField
            placeholderText: "保存路径（可选）"
        }

        Item { height: 1 } // 占位，拉开空间

        // 按钮区
        Row {
            spacing: 12
            anchors.right: parent.right

            Button {
                text: "取消"
                onClicked: addPopup.close()
            }

            Button {
                text: "开始下载"
                enabled: urlField.text.length > 0

                onClicked: {
                    if (pathField.text.length === 0) {
                        pathField.text = "D:/QTprojects/inza_downloader/downloads";
                    }

                    submit(nameField.text, urlField.text, pathField.text)
                    // console.log("URL:", urlField.text)
                    // console.log("Path:", pathField.text)
                    addPopup.close()
                }
            }
        }
    }

    // 弹出 / 收起动画
    enter: Transition {
        ParallelAnimation {
            NumberAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 150
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                property: "scale"
                from: 0.95
                to: 1.0
                duration: 150
                easing.type: Easing.OutCubic
            }
        }
    }

    exit: Transition {
        ParallelAnimation {
            NumberAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 150
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                property: "scale"
                from: 1.0
                to: 0.95
                duration: 150
                easing.type: Easing.OutCubic
            }
        }
    }
}

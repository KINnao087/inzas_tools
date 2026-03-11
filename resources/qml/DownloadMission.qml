import QtQuick
import QtQuick.Effects
import QtQuick.Controls

Item {
    id: wrapper
    property color rectColor: "white"
    property color borderColor: "black"
    property string missionName: ""
    property string missionUrl: ""
    property string missionPath: ""
    property var viewModel // c++自定义qml类型。用来接收渲染信息
    // Component.onCompleted: {
    //     print("Misson: " + viewModel);
    // }

    Rectangle {
        id: card
        anchors.fill: parent
        radius: 5
        border.color: borderColor
        border.width: 0
        Text {
            id: mname
            text: "name: " + missionName
            x: parent.x + 10
            y: parent.y + 20
            font.pixelSize: 20
            color: "#222222"   // 主信息，最深
        }

        Text {
            id: murl
            text: "url: " + missionUrl
            x: parent.x + 10
            y: mname.y + 26
            font.pixelSize: 16
            color: "#666666"   // 次级信息
        }

        Text {
            id: mpath
            text: "path: " + missionPath
            x: parent.x + 10
            y: murl.y + 24
            font.pixelSize: 14
            color: "#999999"   // 辅助信息
        }

        MyProgressBar {
            id: progressBar
            x: mpath.x
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20

            anchors {
                left: parent.left
                right: parent.right
                leftMargin: 10
                rightMargin: 10
            }
            innerColor: "red"
            end: 1000
            height: 2
            value: end * viewModel.progress;
            animationSpeed: 1000
            // onValueChanged: {
            //     print(viewModel.progress);
            //     print(value);
            // }
        }

        // debug
        // Timer {
        //     interval: 50      // 每 50ms 一次
        //     running: true
        //     repeat: true
        //     onTriggered: {
        //         if (progressBar.value < 1000)
        //             progressBar.value += Math.random() * 10
        //         else
        //             stop()
        //     }
        // }
    }
    Behavior on y {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }
    MouseArea {
        anchors.fill: card
        hoverEnabled: true
        onEntered: {
            eft.shadowBlur = 1.0
            wrapper.y -= 5;
        }
        onExited: {
            eft.shadowBlur = 0.5
            wrapper.y += 5;
        }
        onClicked: {
            Qt.openUrlExternally("file:///" + missionPath)
        }
    }

    MultiEffect {
        id: eft

        anchors.fill: card
        source: card

        shadowEnabled: true
        shadowColor: "#40000000"
        shadowBlur: 0.5         // 0~1，越大越糊
        shadowVerticalOffset: 0
        shadowHorizontalOffset: 0

        Behavior on shadowBlur {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
    }
}

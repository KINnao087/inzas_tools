import QtQuick

Item {
    property color barColor: "#000"
    property Window window
    Rectangle {
        id: titelBar
        width: main.width
        height: 40
        color: parent.barColor

        MouseArea {
            anchors.fill: parent
            property real pressX
            property real pressY

            onPressed: (mouse) => {
                pressX = mouse.x
                pressY = mouse.y
            }

            onPositionChanged: (mouse) => {
                root.x += mouse.x - pressX
                root.y += mouse.y - pressY
            }
        }

        Rectangle {
            id: minButton
            color: "transparent"
            radius: 50
            height: parent.height - 10;
            width: parent.height - 10;
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.rightMargin: 40
            Text {
                id: minText
                text: qsTr("-")
                anchors.centerIn: parent
                font.pixelSize: 30
                color: "#000"
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: window.showMinimized()
                onPressed: minText.color = "#7f7f7f"
                onEntered: minText.color = "#3f3f3f"
                onExited: minText.color = "#000"
            }
        }

        Rectangle {
            id: closeButton
            color: "transparent"
            radius: 50
            height: parent.height - 10;
            width: parent.height - 10;
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.rightMargin: 5
            Text {
                id: closeText
                text: qsTr("×")
                anchors.centerIn: parent
                font.pixelSize: 30
                color: "#000"
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: Qt.quit()
                onPressed: closeText.color = "#7f7f7f"
                onEntered: closeText.color = "#3f3f3f"
                onExited: closeText.color = "#000"
            }
        }
    }
}

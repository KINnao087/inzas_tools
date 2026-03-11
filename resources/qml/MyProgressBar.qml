import QtQuick

Item {
    property double value: 0
    property double end: 100
    property color innerColor: "green"
    property color outterColor: "#3f3f3f3f"
    property int animationSpeed: 100


    // onValueChanged: {
    //     print("changed!!!!");
    // }

    Rectangle {
        id: outterBar
        anchors.fill: parent
        color: outterColor

        Rectangle {
            id: innerBar
            color: innerColor
            width: Math.min(parent.width, parent.width * (value / end))
            height: parent.height
            Behavior on width {
                SmoothedAnimation {
                    velocity: animationSpeed
                }
            }
        }
    }
}

import QtQuick
import QtQuick.Controls

Item {
    id: root
    width: 360
    height: 40

    property alias placeholderText: field.placeholderText
    property alias text: field.text
    Component.onCompleted: {
        console.log("INIT text length =", field.text.length)
    }
    Rectangle {
        id: back
        anchors.fill: parent
        radius: 6
        color: "white"
        border.color: "#cccccc"
        border.width: 1
    }
    TextField {
        id: field
        anchors.fill: parent
        font.pixelSize: 14
        verticalAlignment: Text.AlignVCenter
        background: back
        // placeholderTextColor: "red"
        // placeholderText: root.placeholderText
    }
}


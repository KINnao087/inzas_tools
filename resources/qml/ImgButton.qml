import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts

Item {
    width: 40
    height: 40
    property string imgSrcNormal
    property string imgSrcHover
    property string imgSrcPress
    property color onClickedColor
    property color onHoveredColor
    property color onPressedColor
    property int checked: 0

    signal handleClick()

    Image {
        anchors.centerIn: parent
        source: checked == 0 ? imgSrcNormal : (
                checked == 1 ? imgSrcHover : (
                checked == 2 ? imgSrcPress : nullptr))
        width: 30
        height: 30
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            handleClick();
        }
        onPressed: {
            parent.checked = 2
        }
        onReleased: {
            parent.checked = 1
        }
        onEntered: {
            parent.checked = 1
        }
        onExited: {
            parent.checked = 0
        }
    }

}

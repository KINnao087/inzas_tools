import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts

Item {
    id: item
    // 左侧导航栏根节点，需要和内部黑色栏保持同样尺寸
    // 这一层的宽度会直接影响 MainWindow 中右侧内容区的起始位置
    width: rct.width
    height: rct.height

    property alias barWidth: rct.width
    property alias barHeight: rct.height
    property StackLayout stkLayout

    signal showAddPage()

    Rectangle {
        id: rct
        // 左侧黑色导航栏本体，对应界面最左边整列图标区域
        height: barHeight
        width: barWidth
        color: "#0f0f0f"
        anchors.left: parent.left;
        Column {
            // 左栏图标纵向排列，对应头像、列表、添加、机器人按钮的位置
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 28
            anchors.topMargin: 40

            Image {
                id: lain
                width: 50
                height: 50
                source: "qrc:/resources/img/lain.png"
            }

            ImgButton {
                // 第一个按钮：切回下载任务列表页
                width: 50
                height: 50
                imgSrcNormal: "qrc:/resources/img/more.png"
                imgSrcHover:  "qrc:/resources/img/moreHover.png"
                imgSrcPress:  "qrc:/resources/img/morePress.png"
                onHandleClick: {
                    stkLayout.currentIndex = 0;
                }
            }

            ImgButton {
                // 第二个按钮：弹出新增下载任务窗口
                width: 50
                height: 50
                imgSrcNormal: "qrc:/resources/img/add.png"
                imgSrcHover:  "qrc:/resources/img/addHover.png"
                imgSrcPress:  "qrc:/resources/img/addPress.png"
                onHandleClick: {
                    item.showAddPage();
                }
            }

            // agent
            ImgButton {
                // 第三个按钮：切换到 AgentPage
                width: 50
                height: 50
                imgSrcNormal: "qrc:/resources/img/robot_icon.png"
                imgSrcHover:  "qrc:/resources/img/robot_icon_hover.png"
                imgSrcPress:  "qrc:/resources/img/robot_icon_press.png"
                onHandleClick: {
                    stkLayout.currentIndex = 1;
                }
            }
        }
    }
}

import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts

Window {
    id: root
    width: 1240
    height: 980
    visible: true
    flags: Qt.FramelessWindowHint | Qt.Window
    title: "inza_downloader"
    color: "transparent"

    signal handleDownload(string name, string url, string path)

    Connections {
        target: app
        function onDownloadCreated(vm, name, url, path) {
            print("get vm and url: " + url);
            missionPage.pushMission(vm, name, url, path);
        }
    }



    Rectangle {
        id: main
        anchors.fill: parent
        color: "white"
        // 右侧空白显示部分
        StackLayout {
            id: contentStack
            // 主内容区堆栈，对应左侧导航栏右边的整块页面切换区域
            anchors {
                top: titleBar.bottom
                bottom: parent.bottom
                left: leftBar.right
                right: parent.right
            }
            currentIndex: 0

            PageMore {
                id: missionPage

            }

            AgentPage {
                id: agentPage
                objectName: "agentPage"
            }
        }

        //标题栏
        TitleBar {
            id: titleBar
            window: root
            barColor: "transparent"
        }

        //新增下载页面
        PageAdd {
            id: addPage
            onSubmit: (name, url, path) => {
                console.log("MainWindow got:", name, url, path)
                handleDownload(name, url, path);
                //在下载任务界面新增任务
                // missionPage.listModel.append({
                //     name: url,
                //     viewModel: vm
                // });
            }
        }

        //左侧菜单
        LeftBar {
            id: leftBar
            barWidth: 100
            barHeight: parent.height
            stkLayout: contentStack

            onShowAddPage: {
                addPage.open();
            }
        }
    }
}

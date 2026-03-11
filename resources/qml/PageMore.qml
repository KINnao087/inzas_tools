import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Item {
    id: root
    // property var tmpvm;

    function pushMission(vm_, name_, url_, path_) {
        print("PageMode: " + vm_);
        listModel.append({vmodel: vm_, name: name_, murl: url_, path: path_});
        // print("PageMode: " + listModel.get(listModel.count - 1).vmodel + " " + listModel.get(listModel.count - 1).name);
        // tmpvm = vm_;
    }
    // Connections {
    //     target: tmpvm
    //     function onProgressChanged(p) {
    //         print("PageMore: progressChange: " + p);
    //     }
    // }

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        ListModel {
            id: listModel
        }

        ListView {
            anchors.top: parent.top
            anchors.topMargin: 100
            width: parent.width
            height: parent.height
            spacing: 20
            model: listModel

            // delegate: Text {
            //     text: name + " " + vmodel
            // }

            delegate: DownloadMission {
                missionName: name
                viewModel: vmodel
                missionPath: path
                missionUrl: murl
                height: 150
                width: parent.width
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: 150
                    rightMargin: 70
                }
                // 确保安全
                Component.onCompleted: Qt.callLater(() => {
                    if (!viewModel) {
                        console.warn("vm still not ready", index)
                        return
                    }
                    console.log("safe vm =", viewModel, "name =", missionName)
                })
            }

            add: Transition {
                ParallelAnimation {
                    NumberAnimation {
                        property: "scale"
                        from: 0.99
                        to: 1
                        duration: 50
                    }
                    NumberAnimation {
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 50
                    }
                }
            }

        }
    }
}

import QtQuick 1.1

Rectangle {
    height: parent.height > parent.width ? parent.height/16 : parent.height/9.6
    color: "#696969"

    MouseArea {
        id: clickIntercept
        anchors.fill: parent
    }
}

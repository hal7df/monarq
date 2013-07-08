import QtQuick 1.1

Rectangle {
    id: scrollbar
    color: "#343434"
    opacity: 0.5
    radius: horizontal ? height/2 : width/2
    width: horizontal ? undefined : 7
    height: horizontal ? 7 : undefined
    anchors.right: !horizontal ? parent.right : undefined
    anchors.bottom: horizontal ? parent.bottom: undefined
    anchors.margins: 5

    property bool horizontal: false
}

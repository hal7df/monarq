import QtQuick 1.1

Rectangle {
    id: pageMenu

    property bool shown: false
    property int startY
    property int endY

    anchors { left: parent.left; right: parent.right }
    color: "#222222"
    y: startY

    states: State {
        name: "open"; when: shown
        PropertyChanges { target: pageMenu; y: endY }
    }

    transitions: Transition {
        from: ""; to: "open"; reversible: true
        PropertyAnimation { target: pageMenu; properties: "y"; duration: 125 }
    }
}

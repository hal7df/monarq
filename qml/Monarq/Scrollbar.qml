import QtQuick 1.1

Rectangle {
    id: scrollbar
    color: "#444444"
    opacity: 0.0
    width: horizontal ? barSize : 3.5
    height: horizontal ? 3.5 : barSize
    anchors.right: !horizontal ? parent.right : undefined
    anchors.bottom: horizontal ? parent.bottom: undefined
    anchors.margins: 5
    states: State {
        name: "isVisible"; when: shown
        PropertyChanges { target: scrollbar; opacity: 0.25 }
    }
    transitions: Transition {
        from: ""; to: "isVisible"; reversible: true
        NumberAnimation { property: "opacity"; easing.type: Easing.InOutQuad }
    }

    property bool horizontal: false
    property bool shown: false
    property real barSize: 1.0
}

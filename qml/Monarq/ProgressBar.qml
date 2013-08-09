// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: progressBar
    visible: false
    width: progress*parent.width
    anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
    color: "#33B5E5"

    property double progress: 0.0
}

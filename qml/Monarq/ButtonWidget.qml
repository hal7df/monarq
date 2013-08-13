import QtQuick 1.1

ButtonWidgetBase {
    id: buttonWidget

    property alias text: buttonText.text

    width: buttonText.paintedWidth + 10; height: buttonText.paintedHeight + 10
    states: State {
        name: "greyedOut"; when: disabled
        PropertyChanges { target: buttonText; opacity: 0.3 }
    }

    Text {
        id: buttonText
        anchors.centerIn: parent
        color: "#ffffff"
        font.pointSize: 16
    }
}

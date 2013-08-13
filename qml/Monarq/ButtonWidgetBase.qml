import QtQuick 1.1

Rectangle {
    id: buttonWidgetBase

    property color pressedColor: "#33B5E5"
    property bool toggle: false
    property bool toggled: false
    property bool disabled: false //Note: Handling for this property is NOT provided in this component!

    signal clicked

    states: [ State {
            name: "activated"; when: button.pressed && !toggle && !disabled
            PropertyChanges { target: buttonWidgetBase; color: pressedColor }
        },
        State {
            name: "toggleOn"; when: toggled
            PropertyChanges { target: buttonWidgetBase; color: pressedColor }
        }

    ]
    color: "#00000000"

    MouseArea {
        id: button
        anchors.fill: parent
        Component.onCompleted: clicked.connect(parent.clicked);
        enabled: !parent.disabled
        onClicked: {
            if (parent.toggle)
            {
                if (parent.toggled)
                    parent.toggled = false;
                else
                    parent.toggled = true;
            }
        }
    }
}

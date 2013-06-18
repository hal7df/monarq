import QtQuick 1.1
import "IconUtils.js" as IconUtils


Rectangle {
    id: iconWidget
    color: "#00000000"
    width: height
    states: [ State {
        name: "activated"; when: button.pressed && !toggle && !disabled
        PropertyChanges { target: iconWidget; color: pressedColor }
    },
        State {
            name: "toggleOn"; when: toggled
            PropertyChanges { target: iconWidget; color: pressedColor }
        },
        State {
            name: "greyedOut"; when: disabled
            PropertyChanges { target: image; opacity: 0.24 }
        }

    ]

    property color pressedColor: "#29A3CC"
    property string source: ""
    property string category: "navigation"
    property bool srcAbsolute: false
    property alias iconRotation: image.rotation
    property bool toggle: false
    property bool toggled: false
    property bool disabled: false
    signal clicked

    function findIcon()
    {

    }

    Image {
        id: image
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        smooth: true
        source: getIconResolution()

        function getIconResolution()
        {
            if (!parent.srcAbsolute)
                if (height < 48)
                    return "images/mdpi/ic_"+parent.category+"_"+parent.source+".png";
                else if (height >= 48 && height < 64)
                    return "images/hdpi/ic_"+parent.category+"_"+parent.source+".png";
                else
                    return "images/xhdpi/ic_"+parent.category+"_"+parent.source+".png";
            else
                return parent.source;
        }
    }

    MouseArea {
        id: button
        anchors.fill: parent
        Component.onCompleted: clicked.connect(iconWidget.clicked);
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

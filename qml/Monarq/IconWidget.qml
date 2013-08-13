import QtQuick 1.1


ButtonWidgetBase {
    id: iconWidget

    property string source: ""
    property string category: "navigation"
    property bool srcAbsolute: false
    property alias iconRotation: image.rotation

    width: height
    states: State {
        name: "greyedOut"; when: disabled
        PropertyChanges { target: image; opacity: 0.24 }
    }


    Image {
        id: image
        anchors.fill: parent
        anchors.margins: srcAbsolute ? 0.1*parent.width : 0
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
}

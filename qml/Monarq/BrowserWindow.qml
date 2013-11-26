import QtQuick 1.1

Item {
    id: flickContain

    property bool fullscreen: getFullscreen()
    property int toolbarsWidth
    property int maxHeight: parent.height
    property FlickableWebView webObj: webContent

    width: parent.width
    height: getFlickableHeight()
    anchors.top: fullscreen ? addressBar.bottom : parent.top
    anchors.bottom: fullscreen ? actionBar.top : parent.bottom
    anchors.right: parent.right
    anchors.left: parent.left
    z: 5

        FlickableWebView {
            id: webContent
            width: parent.width
            height: parent.height
            settings.pluginsEnabled: true
        }

    Scrollbar {
        id: vertScroll
        barSize: webContent.visibleArea.heightRatio*webContent.height*.95
        y: (webContent.visibleArea.yPosition*webContent.height*.95)+((parent.height*.05)/2)
        shown: webContent.movingVertically
    }

    Scrollbar {
        id: horizontalScroll
        barSize: webContent.visibleArea.widthRatio*webContent.width*.95
        x: (webContent.visibleArea.xPosition*webContent.width*.95)+((parent.width*.05)/2)
        shown: webContent.movingHorizontally
        horizontal: true
    }

    Timer {
        id: visibilityTimer
        interval: 500
        running: webContent.verticalVelocity < 0 ? true : false
        property bool scrollUp: false
        onTriggered: scrollUp = true;
    }

    function getFlickableHeight()
    {
        if (fullscreen)
            return root.height-toolbarsWidth;
        else
            return root.height;
    }

    function getFullscreen()
    {
        if (webContent.verticalVelocity > 0)
            visibilityTimer.scrollUp = false;
        if (webContent.contentY == 0)
            return true;
        else
            return visibilityTimer.scrollUp;
    }
}

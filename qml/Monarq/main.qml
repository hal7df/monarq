import QtQuick 1.1
import QtWebKit 1.0
import "IconUtils.js" as IconUtils

Item {
    id: root
    width: 480
    height: 800

    Toolbar {
        id: addressBar
        visible: webContent.atYBeginning ? true : isUIVisible()
        anchors { top: parent.top; left: parent.left; right: parent.right; }
        z: 20

        ProgressBar {
            id: pageLoadProgress
            visible: webContent.loading
            progress: webContent.progress
        }

        IconWidget {
            id: siteIcon
            anchors { top: parent.top; bottom: parent.bottom; left: parent.left }
            source: webContent.loading ? "images/loading.png" : webContent.icon
            srcAbsolute: true
            iconRotation: !webContent.loading ? 0 : 0
            toggle: true

            PropertyAnimation on iconRotation { from: 0; to: 360; duration: 900; loops: Animation.Infinite; running: webContent.loading }
        }

        Item {
            id: urlInputContainer
            anchors { right: browserLoadControl.left; top: parent.top; bottom: parent.bottom; rightMargin: 5; leftMargin: 5 }
            width: parent.width - (2*parent.height + 5)

            TextInput {
                id: urlInput
                anchors.fill: parent
                width: parent.width
                color: "#ffffff"
                text: webContent.url
                font.pixelSize: parent.height-10
                autoScroll: true
                selectByMouse: true
                inputMethodHints: Qt.ImhNoPredictiveText

                onTextChanged: !webContent.loading ? browserLoadControl.urlChange = true : browserLoadControl.urlChange = false
                onAccepted: goToUrl()

                function goToUrl()
                {
                    webContent.url = text;
                    browserLoadControl.urlChange = false;
                }
            }
        }

        IconWidget {
            id: browserLoadControl
            anchors { top: parent.top; bottom: parent.bottom; right: parent.right; }
            source: getCurrentIcon()
            pressedColor: webContent.progress != 1 ? "#ff0000" : "#29A3CC"
            onClicked: startPageAction()

            property bool urlChange: false

            function getCurrentIcon()
            {
                if (webContent.loading)
                    return "cancel";
                else
                {
                    if (urlChange)
                        return "forward";
                    else
                        return "refresh";
                }
            }

            function startPageAction ()
            {
                urlChange = false;
                siteIcon.toggled = false;
                if (webContent.progress != 1)
                    webContent.stop();
                else
                {
                    if (urlChange)
                        urlInput.goToUrl();
                    else
                        webContent.reload();
                }
            }
        }

        Timer {
            id: visibilityTimer
            interval: 500
            running: webContent.verticalVelocity < 0 ? true : false
            property bool scrollUp: false
            onTriggered: visibilityTimer.scrollUp = true;
        }

        function isUIVisible ()
        {
            if (webContent.verticalVelocity > 0)
                visibilityTimer.scrollUp = false;
            return visibilityTimer.scrollUp;
        }
    }

    Item {
        id: flickContain
        width: parent.width
        height:getFlickableHeight()
        anchors.top: addressBar.visible ? addressBar.bottom : parent.top
        anchors.bottom: addressBar.visible ? actionBar.top : parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        z: 5

            FlickableWebView {
                id: webContent
                width: parent.width
                height: parent.height
                settings.pluginsEnabled: true
                settings.privateBrowsingEnabled: privateButton.toggled
                z: 15
                onLoadFinished: browserLoadControl.urlChanged = false
                onContentXChanged: zoomButton.toggled = false
                onContentYChanged: zoomButton.toggled = false
            }

        Scrollbar {
            id: vertScroll
            barSize: webContent.visibleArea.heightRatio*webContent.height*.95
            y: (webContent.visibleArea.yPosition*webContent.height*.95)+((parent.height*.05)/2)
            shown: webContent.movingVertically
            z: 30
        }

        Scrollbar {
            id: horizontalScroll
            barSize: webContent.visibleArea.widthRatio*webContent.width*.95
            x: (webContent.visibleArea.xPosition*webContent.width*.95)+((parent.width*.05)/2)
            shown: webContent.movingHorizontally
            horizontal: true
            z: 31
        }

        function getFlickableHeight()
        {
            if (addressBar.visible)
                return root.height-100;
            else
                return root.height;
        }
    }


    Toolbar {
        id: actionBar
        visible: addressBar.visible
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
        z: 8

        IconWidget {
            id: backButton
            anchors { top: parent.top; bottom: parent.bottom; left: parent.left; leftMargin: 10 }
            source: "back"
            onClicked: webContent.goBack()
        }

        IconWidget {
            id: privateButton
            anchors { top: parent.top; bottom: parent.bottom; right: parent.horizontalCenter; rightMargin: 20 }
            toggle: true
            source: "images/private.png"
            srcAbsolute: true
        }

        IconWidget {
            id: zoomButton
            anchors { left: parent.horizontalCenter; leftMargin: 20; top: parent.top; bottom: parent.bottom}
            toggle: true
            source: "images/glass.png"
            srcAbsolute: true
        }

        IconWidget {
            id: forwardButtonContainer
            anchors { top: parent.top; bottom: parent.bottom; right: parent.right; rightMargin: 10 }
            source: "forward"
            onClicked: webContent.goForward();
        }
    }

    MinimizedProgressBar {
        id: minimizedProgressBar
        anchors { top: parent.top; horizontalCenter: parent.horizontalCenter; topMargin: 20 }
        progress: webContent.progress
        visible: webContent.loading ? !addressBar.visible : false
        text: webContent.title
        z: 19
    }

    Toolbar {
        id: zoomBar
        visible: zoomButton.toggled
        anchors { right: parent.right; left: parent.left; bottom: actionBar.top }
        z: 7

        ProgressBar {
            id: zoomIndicator
            visible: true
            anchors.left: zoomOut.right
            progress: ((webContent.contentsScale*100)/500)
            width: progress*(parent.width-(zoomIn.width+zoomOut.width))
        }

        Text {
            id: currentZoomLevel
            text: (webContent.contentsScale*100).toFixed(0)+"%"
            color: "#ffffff"
            anchors.centerIn: parent
            font.pointSize: 16
        }

        IconWidget {
            id: zoomOut
            anchors { left: parent.left; bottom: parent.bottom; top: parent.top }
            source: "images/out.png"
            srcAbsolute: true
            disabled: webContent.contentsScale.toFixed(1) <= 0.5 ? true : false
            onClicked: webContent.contentsScale -= 0.1;
        }

        IconWidget {
            id: zoomIn
            anchors { bottom: parent.bottom; right: parent.right; top: parent.top }
            source: "images/in.png"
            srcAbsolute: true
            disabled: webContent.contentsScale.toFixed(1) >= 5.0 ? true : false
            onClicked: webContent.contentsScale += 0.1;
        }

    }

    PageMenu {
        id: pageInfoMenu

        shown: siteIcon.toggled
        height: root.height - addressBar.height; z: 10
        startY: -height
        endY: addressBar.height

        onShownChanged: {
            if (shown)
                zoomBar.visible = false;
        }

        Flickable {
            id:pageInfoScroll

            anchors.fill: parent
            boundsBehavior: Flickable.StopAtBounds
            flickableDirection: Flickable.VerticalFlick

            Item {
                id: pageInfo
                width: root.width

                Text {
                    id: pageName
                    anchors { horizontalCenter: parent.horizontalCenter; top: parent.top; topMargin: 5 }
                    width: parent.width - 10
                    wrapMode: Text.WordWrap
                    font.pointSize: 24
                    color: "#ffffff"
                    text: webContent.title
                    horizontalAlignment: Text.AlignHCenter
                }

                Text {
                    id: faviconSource
                    anchors { horizontalCenter: parent.horizontalCenter; top: pageName.bottom; topMargin: 3 }
                    width: parent.width - 10
                    wrapMode: Text.Wrap
                    font.pointSize: 10
                    color: "#ffffff"
                    text: webContent.icon != "" ? webContent.icon : "No favicon"
                }
            }
        }
    }
}

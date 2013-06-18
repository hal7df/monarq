// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    border.color: "#000000"
    color: "#696969"
    radius: height/4

    width: progressBarText.paintedWidth+10
    height: progressBarText.paintedHeight+6;

    property alias progress: progressBar.progress
    property string text: "Monarq"

    onTextChanged: {
        if (text.length > 40)
            progressBarText.text = text.substring(0,40)+"...";
        else
            progressBarText.text = text;
    }

    ProgressBar {
        id: progressBar
        radius: parent.radius
        visible: true
        anchors.margins: 3
    }

    Text {
        id: progressBarText
        font.pointSize: 14
        color: "#ffffff"
        anchors.centerIn: parent
        text: "Monarq"
    }
}

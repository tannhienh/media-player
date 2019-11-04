import QtQuick 2.13

Image {
    id: headerImage
    signal clickedPlaylistButton(bool playlistStatus)
    source: "qrc:/images/header.png"

    // Open/close Playlist button
    SwitchButton {
        id: playlistButton
        anchors.left: parent.left
        anchors.leftMargin: parent.width / 100
        anchors.verticalCenter: parent.verticalCenter
        icon_on: "qrc:/images/back.png"
        icon_off: "qrc:/images/drawer.png"
        m_width: parent.height * 0.28
        m_height: m_width

        onClicked: {
            headerImage.clickedPlaylistButton(status)
        }
    }

    // Playlist text
    Text {
        id: playlistTextButton
        text: qsTr("Playlist") + translator.emptyString
        color: "White"
        font.pixelSize: parent.height * 0.23
        anchors.left: playlistButton.right
        anchors.leftMargin: parent.width / 300
        anchors.verticalCenter: playlistButton.verticalCenter
    }

    // The title of application
    Text {
        id: headerText
        text: qsTr("Media Player") + translator.emptyString
        font.pixelSize: parent.height * 0.35
        color: "White"
        anchors.centerIn: parent
    }

    Component {
        id: flagHighlight
        Rectangle {
            width: vnFlag.width + border.width * 1.9
            height: vnFlag.height * 0.65
            border.color: "Gray"
            border.width: vnFlag.width / 19
            color: "Transparent"
        }
    }

    // Image vn flag
    Image {
        id: vnFlag
        anchors.right: parent.right
        anchors.rightMargin: parent.width / 100
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height * 0.3
        width: height
        source: "qrc:/images/vn_flag.png"
        opacity: vnFlagHighlight.visible ? 1 : 0.5

        Loader {
            id: vnFlagHighlight
            sourceComponent: flagHighlight
            anchors.centerIn: parent
            visible: translator.getLanguage() === "VN" ? true : false
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (!vnFlagHighlight.visible) {
                    vnFlagHighlight.visible = true
                    usFlagHighlight.visible = false
                    translator.setLanguage("VN")
                }

            }
        }
    }

    // Image us flag
    Image {
        id: usFlag
        anchors.right: vnFlag.left
        anchors.rightMargin: parent.width / 150
        anchors.verticalCenter: vnFlag.verticalCenter
        height: vnFlag.height
        width: height
        source: "qrc:/images/us_flag.png"
        opacity: usFlagHighlight.visible ? 1 : 0.5

        Loader {
            id: usFlagHighlight
            sourceComponent: flagHighlight
            anchors.centerIn: parent
            visible: translator.getLanguage() === "US" ? true : false
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (!usFlagHighlight.visible) {
                    usFlagHighlight.visible = true
                    vnFlagHighlight.visible = false
                    translator.setLanguage("US")
                }
            }
        }
    }
}

import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.13

ApplicationWindow {
    visible: true
    visibility: "FullScreen"
    title: qsTr("Media Player")

    // Background of Application
    Image {
        id: bgImage
        source: "qrc:/images/background.png"
        anchors.fill: parent
    }

    // Header
    AppHeader {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height * 0.13

        onClickedPlaylistButton: {
            if (playlistStatus)
                playlistView.open()
            else
                playlistView.close()
        }
    }

    // Playlist View
    PlaylistView {
        id: playlistView
        y: header.height
        width: parent.width * 0.35
        height: parent.height - header.height
    }

    // Main Media
    MediaInfoControl {
        id: mainMedia
        anchors.top: header.bottom
        anchors.right: bgImage.right
        anchors.bottom: bgImage.bottom
        anchors.leftMargin: 0
        width: bgImage.width - playlistView.position * playlistView.width
    }
}

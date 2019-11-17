import QtQuick 2.13
import QtMultimedia 5.13
import QtQuick.Controls 2.13

Drawer {
    id: drawerPlaylist
    interactive: false
    modal: false

    // Playlist background
    background: Image {
        id: playlistBg
        source: "qrc:/images/playlist_bg.png"
        anchors.fill: parent

    }

    ListView {
        id: mediaPlaylist
        anchors.fill: parent
        model: playlistModel
        spacing: playlistBg.height / 260
        currentIndex: playlist.currentIndex
        clip: true
        delegate: MouseArea {
            id: mouseAreaItem
            width: playlistItem.width
            height: playlistItem.height

            Image {
                id: playlistItem
                source: "qrc:/images/playlist_item.png"
                width: playlistBg.width
                height: (playlistBg.height - (mediaPlaylist.spacing * 5)) / 6
                opacity: 0.5
            }

            // Visible speaker icon when playing
            function checkPlaying() {
                if (mouseAreaItem.ListView.isCurrentItem)
                    if (player.state === MediaPlayer.PlayingState) {
                        changeSpeaker.restart()
                        return true;
                    }
                return false;
            }

            Image {
                id: speakerImage
                source: "qrc:/images/playing.png"
                width: playlistItem.height * 0.2
                height: width
                anchors.left: playlistItem.left
                anchors.leftMargin: playlistItem.width / 50
                anchors.verticalCenter: playlistItem.verticalCenter
                visible: checkPlaying()
            }

            Text {
                id: nameSong
                text: title == "" ? "Unknown" : title
                color: "white"
                font.pixelSize: playlistItem.height * 0.2
                anchors.left: speakerImage.right
                anchors.leftMargin: playlistItem.width / 50
                anchors.verticalCenter: playlistItem.verticalCenter
                opacity: mouseAreaItem.ListView.isCurrentItem ? 1 : 0.5
            }

            onPressed: {
                playlistItem.source = "qrc:/images/hold.png"
            }

            onReleased: {
                playlistItem.source =
                        "qrc:/images/playlist_item.png"
            }

            onClicked: {
                if (mediaPlaylist.currentIndex != index) {
                    player.playlist.currentIndex = index
                    changeTitle.restart()
                    changeSpeaker.restart()
                }
            }

            onCanceled: {
                playlistItem.source =
                        "qrc:/images/playlist_item.png"
            }

            PropertyAnimation {
                id: changeTitle
                property: "opacity"
                from: 0.5; to: 1
                target: nameSong
                duration: 500
                easing.type: Easing.InQuad
            }

            PropertyAnimation {
                id: changeSpeaker
                property: "opacity"
                from: 0; to: 1
                target: speakerImage
                duration: 600
                easing.type: Easing.InQuad
            }
        }

        highlight: Image {
            source: "qrc:/images/playlist_item.png"
        }

        // Scrollbar
        ScrollBar.vertical: ScrollBar {
            parent: mediaPlaylist.parent
            anchors.top: mediaPlaylist.top
            anchors.left: mediaPlaylist.right
            anchors.bottom: mediaPlaylist.bottom
        }

        Connections {
            target: playlist
            onCurrentIndexChanged:
                mediaPlaylist.currentIndex = index
        }
    }
}

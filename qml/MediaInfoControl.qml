import QtQuick 2.13
import QtQuick.Controls 2.13
import QtMultimedia 5.13
import QtGraphicalEffects 1.13

Item {
    // Media Info
    Item {
        id: mediaInfo
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height * 0.12

        // Dark effect on top media info
        Rectangle {
            anchors.fill: parent

            gradient: Gradient {
                GradientStop {
                    position: -0.5
                    color: "#FF000000"
                }

                GradientStop {
                    position: 1
                    color: "#00000000"
                }
            }
        }

        // Song title
        Text {
            id: audioTitle
            anchors.top: parent.top
            anchors.topMargin: mediaInfo.height * 0.14
            anchors.left: parent.left
            anchors.leftMargin: mediaInfo.width / 70
            text: albumArtView.currentItem.getData.title === "" ? "Unknown" : albumArtView.currentItem.getData.title
            color: "White"
            font.pixelSize: mediaInfo.height * 0.32
        }

        // Singer
        Text {
            id: audioSinger
            anchors.top: audioTitle.bottom
            anchors.left: parent.left
            anchors.leftMargin: mediaInfo.width / 70
            text: albumArtView.currentItem.getData.singer === "" ? "Unknown" : albumArtView.currentItem.getData.singer
            color: "LightGray"
            font.pixelSize: mediaInfo.height * 0.27
        }

        // Icon Amount of song
        Image {
            id: counterIcon
            source: "qrc:/images/music.png"
            height: mediaInfo.height * 0.35
            width: height
            anchors.right: songAmount.left
            anchors.rightMargin: mediaInfo.height * 0.1
            anchors.verticalCenter: mediaInfo.verticalCenter
        }

        // Amount of song in playlist
        Text {
            id: songAmount
            text: albumArtView.count
            color: "white"
            font.pixelSize: mediaInfo.height * 0.35
            anchors.right: mediaInfo.right
            anchors.rightMargin: mediaInfo.height * 0.2
            anchors.verticalCenter: mediaInfo.verticalCenter
        }
    }

    // Album Art Item
    Item {
        id: albumArtItem
        anchors.top: mediaInfo.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height * 0.6

        // Delegate for album art view
        Component {
            id: albumArtDelegate

            Item {
                property variant getData: model
                width: albumArtItem.height * 0.65
                height: width
                scale: PathView.iconScale
                opacity: PathView.isCurrentItem ? 1 : 0.8

                Image {
                    id: albumPicture
                    width: parent.width
                    height: parent.height
                    anchors.centerIn: parent
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: album_art
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: albumArtView.currentIndex = index
                }

                DropShadow {
                    anchors.fill: albumPicture
                    color: "#aa000000"
                    radius: 80
                    samples: 100
                    horizontalOffset: 20
                    verticalOffset: 80
                    spread: 0
                    source: albumPicture
                }
            }
        }

        // AlbumArt View
        PathView {
            id: albumArtView
            anchors.leftMargin: (albumArtItem.width - (albumArtItem.height * 1.8)) / 2
            anchors.fill: albumArtItem
            preferredHighlightBegin: 0.5
            preferredHighlightEnd: 0.5
            focus: true
            model: appModel
            delegate: albumArtDelegate
            pathItemCount: 3

            path: Path {
                startX: 0
                startY: albumArtItem.height * 0.45
                PathAttribute { name: "iconScale"; value: 0.5 }
                PathLine { x: albumArtItem.height * 0.9; y: albumArtItem.height * 0.45}
                PathAttribute { name: "iconScale"; value: 1.0 }
                PathLine { x: albumArtItem.height * 1.8; y: albumArtItem.height * 0.45}
                PathAttribute { name: "iconScale"; value: 0.5 }
            }

            onCurrentIndexChanged: {
                albumArtView.currentIndex = currentIndex
                player.playlist.currentIndex = currentIndex
            }

            PropertyAnimation {
                id: changeText
                property: "opacity"
                from: 0; to: 1
                duration: 500
                easing.type: Easing.InOutCubic
            }

            onCurrentItemChanged: {
                changeText.targets = [audioTitle, audioSinger]
                changeText.restart()
            }
        }

        Connections {
            target: player.playlist
            onCurrentIndexChanged: {
                albumArtView.currentIndex = index
            }
        }
    }

    // ProgressBar
    Item {
        id: progressBarItem
        anchors.left: parent.left
        anchors.bottom: mediaControl.top
        anchors.right: parent.right
        height: parent.height / 20

        // Current time playing
        Text {
            id: currentTime
            text: utility.getTimeInfo(player.position)
            color: "White"
            anchors.left: progressBarItem.left
            anchors.leftMargin: 150
            anchors.verticalCenter: progressBar.verticalCenter
            font.pixelSize: parent.height * 0.4
        }

        Slider{
            id: progressBar
            anchors.left: currentTime.right
            anchors.leftMargin: 20
            anchors.right: totalTime.left
            anchors.rightMargin: 20
            anchors.verticalCenter: progressBarItem.verticalCenter
            from: 0.0
            to: player.duration
            value: player.position

            background: Rectangle {
                id: aa
                x: progressBar.leftPadding
                y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
                width: progressBar.availableWidth
                height: progressBarItem.height * 0.127
                radius: height
                color: "gray"

                Rectangle {
                    width: progressBar.visualPosition * parent.width
                    height: parent.height
                    color: "white"
                    radius: 5
                }
            }

            handle: Image {
                id: point
                source: "qrc:/images/point.png"
                width: progressBarItem.height * 0.5
                height: width + 2
                anchors.verticalCenter: parent.verticalCenter
                x: progressBar.leftPadding + progressBar.visualPosition * (progressBar.availableWidth - width / 2)
                y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
                Image {
                    id: centerPoint
                    anchors.centerIn: parent
                    source: "qrc:/images/center_point.png"
                    width: point.width * 0.7
                    height: width
                }
            }

            onPressedChanged: {
                player.setPosition(Math.floor(position * player.duration))
            }
        }

        // Total time of song
        Text {
            id: totalTime
            text: utility.getTimeInfo(player.duration)
            color: "White"
            anchors.right: progressBarItem.right
            anchors.rightMargin: 150
            anchors.verticalCenter: progressBar.verticalCenter
            font.pixelSize: parent.height * 0.4
        }
    }

    // Media Control
    Item {
        id: mediaControl
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        height: parent.height / 6
        anchors.bottomMargin: parent.height / 25

        // Previous button
        ButtonControl {
            id: prevButton
            m_height: mediaControl.height * 0.37
            m_width: m_height * 1.51
            anchors.right: playButton.left
            anchors.verticalCenter: playButton.verticalCenter
            icon_default: "qrc:/images/prev.png"
            icon_pressed: "qrc:/images/prev_hold.png"
            icon_released: "qrc:/images/prev.png"

            onClicked: {
                if (player.playlist.currentIndex !== 0 || repeatButton.status || shuffleButton.status)
                    utility.previous(player);
            }
        }

        // Play/Pause button
        ButtonControl {
            id: playButton
            m_height: mediaControl.height * 0.85
            m_width: m_height - 1
            anchors.centerIn: mediaControl

            status: player.state === MediaPlayer.PlayingState ? true : false
            icon_default: status ? "qrc:/images/pause.png" : "qrc:/images/play.png"
            icon_pressed: status ? "qrc:/images/pause_hold.png" : "qrc:/images/play_hold.png"
            icon_released: status ? "qrc:/images/play.png" : "qrc:/images/pause.png"

            onClicked: {
                if (playButton.status)
                    utility.pause(player);
                else
                    utility.play(player);
            }

            Connections {
                target: player
                onStateChanged: {
                    if (player.state === MediaPlayer.PlayingState)
                        playButton.source_default = "qrc:/images/pause.png"
                    else
                        playButton.source_default = "qrc:/images/play.png"
                }
            }
        }

        // Next button
        ButtonControl {
            id: nextButton
            m_width: prevButton.m_width
            m_height: prevButton.m_height
            anchors.left: playButton.right
            anchors.verticalCenter: playButton.verticalCenter
            icon_default: "qrc:/images/next.png"
            icon_pressed: "qrc:/images/next_hold.png"
            icon_released: "qrc:/images/next.png"

            onClicked: {
                if (player.playlist.currentIndex !== (albumArtView.count - 1) || repeatButton.status || shuffleButton.status)
                    utility.next(player);
            }
        }

        // Shuffle button
        SwitchButton {
            id: shuffleButton
            m_height: mediaControl.height * 0.33
            m_width: m_height * 2.04
            anchors.left: mediaControl.left
            anchors.leftMargin: 150
            anchors.verticalCenter: mediaControl.verticalCenter
            icon_on: "qrc:/images/shuffle_hold.png"
            icon_off: "qrc:/images/shuffle.png"
            status: player.playlist.playbackMode === Playlist.Random ? 1 : 0

            onStatusChanged: {
                if (shuffleButton.status) {
                    repeatButton.status = false
                    utility.shuffle(player, 1)
                }
                else
                    utility.shuffle(player, 0)
            }
        }

        // Repeat button - loops current track
        SwitchButton {
            id: repeatButton
            m_width: shuffleButton.width
            m_height: shuffleButton.height
            anchors.right: mediaControl.right
            anchors.rightMargin: 150
            anchors.verticalCenter: mediaControl.verticalCenter
            icon_on: "qrc:/images/repeat_hold.png"
            icon_off: "qrc:/images/repeat.png"
            status: player.playlist.playbackMode === Playlist.Loop ? 1 : 0

            onStatusChanged: {
                if (repeatButton.status) {
                    shuffleButton.status = false
                    utility.loop(player, 1)
                }
                else
                    utility.loop(player, 0)
            }
        }
    }
}

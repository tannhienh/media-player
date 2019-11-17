import QtQuick 2.13
import QtQuick.Controls 2.13
import QtMultimedia 5.13
import QtGraphicalEffects 1.13

Item {
    // Media Info
    Item {
        id: mediaInfo
        height: parent.height * 0.12 // 870 * 0.12 = 104.4
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

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

            text: if (playlistModel.rowCount() > 0)
                    return (albumArtView.currentItem.getData.title === ""
                            ? "Unknown" : albumArtView.currentItem.getData.title)
                  else
                    return ""

            color: "White"
            font.pixelSize: mediaInfo.height * 0.32
            font.family: cantarell.name
            anchors{
                top: parent.top
                topMargin: mediaInfo.height * 0.14 //  14.56
                left: parent.left
                leftMargin: mediaInfo.width / 70
            }
        }

        // Singer
        Text {
            id: audioSinger
            text: if (playlistModel.rowCount() > 0)
                    return (albumArtView.currentItem.getData.singer === ""
                            ? "Unknown" : albumArtView.currentItem.getData.singer)
                  else
                    return ""

            color: "LightGray"
            font.pixelSize: mediaInfo.height * 0.27
            font.family: cantarell.name
            anchors {
                top: audioTitle.bottom
                left: parent.left
                leftMargin: mediaInfo.width / 70
            }
        }

        // Icon Amount of song
        Image {
            id: counterIcon
            source: "qrc:/images/music.png"
            height: mediaInfo.height * 0.35
            width: height
            anchors {
                right: songAmount.left
                rightMargin: mediaInfo.height * 0.1
                verticalCenter: mediaInfo.verticalCenter
            }
        }

        // Amount of song in playlist
        Text {
            id: songAmount
            text: albumArtView.count
            color: "white"
            font.pixelSize: mediaInfo.height * 0.35
            font.family: cantarell.name
            anchors {
                right: mediaInfo.right
                rightMargin: mediaInfo.height * 0.2
                verticalCenter: mediaInfo.verticalCenter
            }
        }
    }

    // Album Art Item
    Item {
        id: albumArtItem
        height: parent.height * 0.6
        anchors {
            top: mediaInfo.bottom
            left: parent.left
            right: parent.right
        }


        // Delegate for album art view
        Component {
            id: albumArtDelegate

            Item {
                property variant getData: model
                width: albumArtItem.height * 0.65
                height: width
                scale:  PathView.iconScale === undefined ? 0 : PathView.iconScale
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
                    onClicked: if (player.playlist.currentIndex != index)
                                    player.playlist.currentIndex = index
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

                transform: Scale {
                    origin.x: 0.5
                    origin.y: 0.5
                }
            }
        }

        // AlbumArt View
        PathView {
            id: albumArtView
            anchors.leftMargin: (albumArtItem.width -
                                 (albumArtItem.height * 1.8)) / 2
            anchors.fill: albumArtItem
            preferredHighlightBegin: 0.5
            preferredHighlightEnd: 0.5
            focus: true
            model: playlistModel
            delegate: albumArtDelegate
            pathItemCount: 3
            currentIndex: playlist.currentIndex

            path: Path {
                startX: 0
                startY: albumArtItem.height * 0.45
                PathAttribute { name: "iconScale"; value: 0.5 }
                PathLine {
                    x: albumArtItem.height * 0.9
                    y: albumArtItem.height * 0.45
                }
                PathAttribute { name: "iconScale"; value: 1.0 }
                PathLine {
                    x: albumArtItem.height * 1.8
                    y: albumArtItem.height * 0.45
                }
                PathAttribute { name: "iconScale"; value: 0.5 }
            }

            onCurrentIndexChanged: {
                changeText.targets = [audioTitle, audioSinger]
                changeText.restart()
            }


            PropertyAnimation {
                id: changeText
                property: "opacity"
                from: 0; to: 1
                duration: 500
                easing.type: Easing.InOutCubic
            }
        }

        Connections {
            target: playlist
            onCurrentIndexChanged: {
                albumArtView.currentIndex = index
            }
        }
    }

    // ProgressBar
    Item {
        id: progressBarItem
        height: parent.height / 20
        anchors {
            left: parent.left
            bottom: mediaControl.top
            right: parent.right
        }

        // Current time playing
        Text {
            id: currentTime
            text: utility.getTimeInfo(player.position)
            color: "White"
            font.pixelSize: parent.height * 0.4
            font.family: cantarell.name
            anchors {
                left: progressBarItem.left
                leftMargin: 150
                verticalCenter: progressBar.verticalCenter
            }
        }

        Slider{
            id: progressBar
            from: 0.0
            to: player.duration
            value: player.position
            anchors {
                left: currentTime.right
                leftMargin: 20
                right: totalTime.left
                rightMargin: 20
                verticalCenter: progressBarItem.verticalCenter
            }

            background: Rectangle {
                x: progressBar.leftPadding
                y: progressBar.topPadding + (progressBar.availableHeight / 2)
                   - (height / 2)
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
                x: progressBar.leftPadding + progressBar.visualPosition *
                   (progressBar.availableWidth - width / 2)
                y: progressBar.topPadding + (progressBar.availableHeight / 2)
                   - height / 2
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
            font.family: cantarell.name
            color: "White"
            font.pixelSize: parent.height * 0.4
            anchors {
                right: progressBarItem.right
                rightMargin: 150
                verticalCenter: progressBar.verticalCenter
            }
        }
    }

    // Media Control
    Item {
        id: mediaControl
        height: parent.height / 6
        anchors {
            left: parent.left
            bottom: parent.bottom
            right: parent.right
            bottomMargin: parent.height / 25
        }

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
                if (player.playlist.currentIndex !== 0 || repeatButton.status
                    || shuffleButton.status)
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
            icon_default: status ? "qrc:/images/pause.png" :
                                   "qrc:/images/play.png"
            icon_pressed: status ? "qrc:/images/pause_hold.png" :
                                   "qrc:/images/play_hold.png"
            icon_released: status ? "qrc:/images/play.png" :
                                    "qrc:/images/pause.png"

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
                        playButton.source_default =
                                "qrc:/images/pause.png"
                    else
                        playButton.source_default =
                                "qrc:/images/play.png"
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
                if (player.playlist.currentIndex !== (albumArtView.count - 1)
                        || repeatButton.status || shuffleButton.status)
                    utility.next(player);
            }
        }

        // Shuffle button
        SwitchButton {
            id: shuffleButton
            m_height: mediaControl.height * 0.33
            m_width: m_height * 2.04
            anchors {
                left: mediaControl.left
                leftMargin: 150
                verticalCenter: mediaControl.verticalCenter
            }
            icon_on: "qrc:/images/shuffle_hold.png"
            icon_off: "qrc:/images/shuffle.png"
            status: playlist.playbackMode === Playlist.Random ? 1 : 0

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
            anchors {
                right: mediaControl.right
                rightMargin: 150
                verticalCenter: mediaControl.verticalCenter
            }
            icon_on: "qrc:/images/repeat_hold.png"
            icon_off: "qrc:/images/repeat.png"
            status: playlist.playbackMode === Playlist.Loop ? 1 : 0

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

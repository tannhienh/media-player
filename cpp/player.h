#ifndef PLAYER_H
#define PLAYER_H

#include <QMediaPlayer>
#include <QMediaPlaylist>
#include <taglib/tag.h>
#include <taglib/fileref.h>
#include <taglib/id3v2tag.h>
#include <taglib/mpegfile.h>
#include <taglib/id3v2frame.h>
#include <taglib/id3v2header.h>
#include <taglib/attachedpictureframe.h>

QT_BEGIN_NAMESPACE

// provides the basic functionality for item view classes
class QAbstractItemView;

// allows the playing of a media source
class QMediaPlayer;

QT_END_NAMESPACE

class PlaylistModel;    // PlaylistModel class declaration

using namespace TagLib; // using namespace TagLib library

class Player : public QObject
{
    Q_OBJECT
public:
    // Constructor Player function
    explicit Player(QObject *parent = nullptr);

    // Add list of audios to playlist model
    void addToPlaylist(const QList<QUrl> &urls);

public slots:
    // Load audios from default location of Music directory which are mp3 file
    // get path for add to playlist
    void open();

    QString getTimeInfo(qint64 currentInfo); // get current time and total time

    void previous(QMediaPlayer *);      // Previous song in playlist

    void play(QMediaPlayer *);          // Play media process

    void pause(QMediaPlayer *);         // Pause media process

    void next(QMediaPlayer *);          // Next song in playlist

    void shuffle(QMediaPlayer *, bool); // Set shuffle mode for playlist

    void loop(QMediaPlayer *, bool);    // Set loop mode for playlist

    QString getAlbumArt(QUrl url);      // Get album art from audio file

public:
    QMediaPlayer *m_player = nullptr;   // Pointer for media player
    QMediaPlaylist *m_playlist = nullptr;   // Pointer for media playlist
    PlaylistModel *m_playlistModel = nullptr;   // Pointer for playlist model
};

#endif // PLAYER_H

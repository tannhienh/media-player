#include "cpp/player.h"
#include "cpp/playlistmodel.h"

#include <QMediaService>
#include <QMediaPlaylist>
#include <QMediaMetaData>
#include <QObject>
#include <QFileInfo>
#include <QTime>
#include <QDir>
#include <QStandardPaths>

Player::Player(QObject *parent)
    : QObject(parent)
{
    m_player = new QMediaPlayer(this);
    m_playlist = new QMediaPlaylist(this);
    m_player->setPlaylist(m_playlist);
    m_playlistModel = new PlaylistModel(this);
    open();
    if (!m_playlist->isEmpty()) {
        m_playlist->setCurrentIndex(0);
    }
}

// Load audios from default location of Music directory which are mp3 file
// get path for add to playlist
void Player::open()
{
    QDir directory(QStandardPaths::standardLocations(QStandardPaths::MusicLocation)[0]);
    QFileInfoList musics = directory.entryInfoList(QStringList() << "*.mp3", QDir::Files);
    QList<QUrl> urls;
    for (int i = 0; i < musics.length(); i++){
        urls.append(QUrl::fromLocalFile(musics[i].absoluteFilePath()));
    }

    addToPlaylist(urls);
}

// add list of audios to playlist model
void Player::addToPlaylist(const QList<QUrl> &urls)
{
    for (auto &url: urls) {

        m_playlist->addMedia(url);

        FileRef f(url.path().toStdString().c_str());
        Tag *tag = f.tag();
        Song song(QString::fromWCharArray(tag->title().toCWString()),
                  QString::fromWCharArray(tag->artist().toCWString()),
                  url.toDisplayString(),
                  getAlbumArt(url));

        m_playlistModel->addSong(song);
    }
}

// Get current time and total time
QString Player::getTimeInfo(qint64 timeInput)
{
    timeInput /= 1000;
    QTime time((timeInput / 3600) % 60, (timeInput / 60) % 60,
               timeInput % 60, (timeInput * 1000) % 1000);
    QString format = "mm:ss";
    if (timeInput > 3600)
        format = "hh:mm:ss";
    QString timeFormated = time.toString(format);

    return timeFormated;
}

// Previous process
void Player::previous(QMediaPlayer *player)
{
    player->playlist()->previous();
}

// Play process
void Player::play(QMediaPlayer *player)
{
    player->play();
}

// Pause precess
void Player::pause(QMediaPlayer *player)
{
    player->pause();
}

// Next process
void Player::next(QMediaPlayer *player)
{
    player->playlist()->next();
}

// Shuffle process
void Player::shuffle(QMediaPlayer *player, bool status)
{
    if (status)
        player->playlist()->setPlaybackMode(QMediaPlaylist::Random);
    else
        player->playlist()->setPlaybackMode(QMediaPlaylist::Sequential);
}

// Repeat process
void Player::loop(QMediaPlayer *player, bool status)
{
    if (status)
        player->playlist()->setPlaybackMode(QMediaPlaylist::Loop);
    else
        player->playlist()->setPlaybackMode(QMediaPlaylist::Sequential);
}

// Get album art from audio file
QString Player::getAlbumArt(QUrl url)
{
    static const char *IdPicture = "APIC" ;
    MPEG::File mpegFile(url.path().toStdString().c_str());
    ID3v2::Tag *id3v2tag = mpegFile.ID3v2Tag();
    ID3v2::FrameList Frame ;
    ID3v2::AttachedPictureFrame *PicFrame ;
    void *SrcImage ;
    unsigned long Size ;

    FILE *jpegFile;
    jpegFile = fopen(QString(url.fileName()+".jpg").toStdString().c_str(),"wb");

    if ( id3v2tag )
    {
        // picture frame
        Frame = id3v2tag->frameListMap()[IdPicture] ;
        if (!Frame.isEmpty() )
        {
            for(ID3v2::FrameList::ConstIterator it = Frame.begin(); it != Frame.end(); ++it)
            {
                PicFrame = static_cast<ID3v2::AttachedPictureFrame*>(*it) ;
                {
                    Size = PicFrame->picture().size() ;
                    SrcImage = malloc ( Size ) ;
                    if ( SrcImage )
                    {
                        memcpy ( SrcImage, PicFrame->picture().data(), Size ) ;
                        fwrite(SrcImage,Size,1, jpegFile);
                        fclose(jpegFile);
                        free( SrcImage ) ;
                        return QUrl::fromLocalFile(url.fileName()+".jpg").toDisplayString();
                    }

                }
            }
        }
    }
    else
    {
        return "qrc:/images/album_art.png";
    }
    return "qrc:/images/album_art.png";
}

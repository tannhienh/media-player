#include "cpp/playlistmodel.h"

#include <QFileInfo>
#include <QUrl>
#include <QMediaPlaylist>

//----------------------------------------------------------------------------//
// Song class
//
// Assign songs info
Song::Song(const QString &title, const QString &singer, const QString &source,
           const QString &albumArt)
{
    m_title = title;
    m_singer = singer;
    m_source = source;
    m_albumArt = albumArt;
}

// Get song title
QString Song::title() const
{
    return m_title;
}

// Get song single
QString Song::singer() const
{
    return m_singer;
}

// Get song source
QString Song::source() const
{
    return m_source;
}

// Get song album art
QString Song::album_art() const
{
    return m_albumArt;
}
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
// PlaylistModel class
//
PlaylistModel::PlaylistModel(QObject *parent) : QAbstractListModel(parent)
{
}

// Return the number of songs in list m_data
int PlaylistModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_data.count();
}

// Get songs info: title, single, source, album art
QVariant PlaylistModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_data.count())
        return QVariant();

    const Song &song = m_data[index.row()];
    if (role == TitleRole)
        return song.title();
    else if (role == SingerRole)
        return song.singer();
    else if (role == SourceRole)
        return song.source();
    else if (role == AlbumArtRole)
        return song.album_art();

    return QVariant();
}

// add songs to QList container m_data
void PlaylistModel::addSong(Song &song)
{
        m_data.append(song);
}

// Create hash table for roles a song
QHash<int, QByteArray> PlaylistModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names[TitleRole] = "title";
    names[SingerRole] = "singer";
    names[SourceRole] = "source";
    names[AlbumArtRole] = "album_art";
    return names;
}
//----------------------------------------------------------------------------//

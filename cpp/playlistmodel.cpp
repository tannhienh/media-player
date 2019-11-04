#include "cpp/playlistmodel.h"

#include <QFileInfo>
#include <QUrl>
#include <QMediaPlaylist>

PlaylistModel::PlaylistModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

// Get amount audios in playlist
int PlaylistModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_data.count();
}

// Get audio info: title, single, source, album art
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

// add audio to QList container m_data
void PlaylistModel::addSong(Song &song)
{
        m_data.append(song);
}

QHash<int, QByteArray> PlaylistModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names[TitleRole] = "title";
    names[SingerRole] = "singer";
    names[SourceRole] = "source";
    names[AlbumArtRole] = "album_art";
    return names;
}

// Assign audio info
Song::Song(const QString &title, const QString &singer, const QString &source, const QString &albumArt)
{
    m_title = title;
    m_singer = singer;
    m_source = source;
    m_albumArt = albumArt;
}

// Get audio title
QString Song::title() const
{
    return m_title;
}

// Get audio single
QString Song::singer() const
{
    return m_singer;
}

// Get audio source
QString Song::source() const
{
    return m_source;
}

// Get audio album art
QString Song::album_art() const
{
    return m_albumArt;
}

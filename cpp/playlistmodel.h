#ifndef PLAYLISTMODEL_H
#define PLAYLISTMODEL_H

#include <QAbstractListModel>
#include <QScopedPointer>

QT_BEGIN_NAMESPACE
class QMediaPlaylist;   //provides a list of media content to play
QT_END_NAMESPACE

//----------------------------------------------------------------------------//
// Song class
//
class Song
{
public:
    // Constructor Song function
    Song(const QString &title, const QString &singer, const QString &source,
         const QString &albumArt);

    QString title() const;      // Get title of song

    QString singer() const;     // Get singer of song

    QString source() const;     // Get source path of song

    QString album_art() const;  // Get album art of song

private:
    QString m_title;    // title of song
    QString m_singer;   // singer of song
    QString m_source;   // source path of song
    QString m_albumArt; // album art of song
};
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
// PlaylistModel class
//
class PlaylistModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum Roles {
        TitleRole = Qt::UserRole + 1,
        SingerRole,
        SourceRole,
        AlbumArtRole
    };

    // Constructor function
    explicit PlaylistModel(QObject *parent = nullptr);

    // Return the number of songs in list m_data
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    // Get audio info: title, single, source, album art
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole)
                  const override;

    // add audio to QList container m_data
    void addSong(Song &song);

protected:
    // Create hash table for roles a song
    QHash<int, QByteArray> roleNames() const override;

private:
    QList<Song> m_data; // Create m_data store list songs
};
#endif // PLAYLISTMODEL_H
//----------------------------------------------------------------------------//

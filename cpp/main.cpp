#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "cpp/player.h"
#include "cpp/playlistmodel.h"
#include "cpp/translation.h"

// Set default language for application
// English: EN
// Vietnamese: VN
#define DEFAULT_LANGUAGE "US"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    qRegisterMetaType<QMediaPlaylist*>("QMediaPlaylist*");

    QQmlApplicationEngine engine;

    //------------------------------------------------------------------------//
    // Translation
    Translation translator(&app);
    translator.setLanguage(DEFAULT_LANGUAGE);
    engine.rootContext()->setContextProperty("translator", &translator);
    //------------------------------------------------------------------------//

    //------------------------------------------------------------------------//
    // Media Player
    Player player;
    engine.rootContext()->setContextProperty("playlistModel", player.m_playlistModel);
    engine.rootContext()->setContextProperty("player", player.m_player);
    engine.rootContext()->setContextProperty("playlist", player.m_playlist);
    engine.rootContext()->setContextProperty("utility", &player);
    //------------------------------------------------------------------------//

    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}

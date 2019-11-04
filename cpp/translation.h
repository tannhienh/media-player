#ifndef TRANSLATION_H
#define TRANSLATION_H

#include <QObject>
#include <QTranslator>
#include <QGuiApplication>

class Translation : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString emptyString READ getEmptyString NOTIFY languageChanged)

public:
    Translation(QGuiApplication *app, QObject *parent = nullptr);
    QString getEmptyString();

signals:
    void languageChanged();

public slots:
    void setLanguage(QString language);
    QString getLanguage();

private:
    QTranslator m_translator;
    QGuiApplication *m_app;
    QString m_language;
};

#endif // TRANSLATION_H

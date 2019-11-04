#include "cpp/translation.h"
#include <iostream>

Translation::Translation(QGuiApplication *app, QObject *parent) : QObject(parent)
{
    m_app = app;
}

// Get empty string
QString Translation::getEmptyString()
{
    return "";
}

// Get current language
QString Translation::getLanguage()
{
    return m_language;
}

// Set current language
void Translation::setLanguage(QString language)
{
    if (language != m_language)
        m_language = language;

    if (language == "VN")
        m_translator.load(":/translator/string_vn.qm");

    if (language == "US")
        m_translator.load(":/translator/string_us.qm");

    m_app->installTranslator(&m_translator);

    emit languageChanged();
}

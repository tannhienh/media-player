QT += quick core multimedia
CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    cpp/main.cpp \
    cpp/player.cpp \
    cpp/playlistmodel.cpp \
    cpp/translation.cpp

RESOURCES += qml.qrc \
    fonts.qrc \
    images.qrc \
    translator.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

LIBS += -ltag

HEADERS += \
    cpp/player.h \
    cpp/playlistmodel.h \
    cpp/translation.h

TRANSLATIONS =  translator/string_vn.ts \
                translator/string_us.ts

DISTFILES += \
    LICENSE \
    README.md

import QtQuick 2.13

MouseArea {
    property string icon_default: ""
    property string icon_pressed: ""
    property string icon_released: ""
    property alias source_default: img.source
    property bool status
    property variant m_width
    property variant m_height

    implicitWidth: img.width
    implicitHeight: img.height

    Image {
        id: img
        source: icon_default
        width: m_width
        height: m_height
    }

    onPressed: {
        img.source = icon_pressed
    }

    onReleased: {
        img.source = icon_released
    }
}

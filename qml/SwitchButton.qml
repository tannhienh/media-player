import QtQuick 2.13

MouseArea {
    id: root

    property string icon_on: ""
    property string icon_off: ""
    property bool status: false
    property variant m_width
    property variant m_height

    implicitWidth: img.width
    implicitHeight: img.height

    Image {
        id: img
        source: root.status === true ? icon_on : icon_off
        width: m_width
        height: m_height
    }

    onClicked: {
        if (root.status)
            root.status = false
        else
            root.status = true
    }
}

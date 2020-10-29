/*
 * Copyright 2020  Kevin Donnelly
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http: //www.gnu.org/licenses/>.
 */
import QtQuick 2.9

import QtQuick.Layouts 1.3

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import "../code/utils.js" as Utils

ColumnLayout {
    id: compactRoot

    readonly property bool vertical: (plasmoid.formFactor == PlasmaCore.Types.Vertical)
    readonly property bool showTemperature: !inTray

    function printDebug(msg) {
        console.log("[debug] " + msg)
    }

    Loader {
        id: loader

        sourceComponent: showTemperature ? iconAndTextComponent : iconComponent
        Layout.fillWidth: compactRoot.vertical
        Layout.fillHeight: !compactRoot.vertical
        Layout.minimumWidth: item.Layout.minimumWidth
        Layout.minimumHeight: item.Layout.minimumHeight

        MouseArea {
            id: compactMouseArea
            anchors.fill: parent

            hoverEnabled: true

            onClicked: {
                plasmoid.expanded = !plasmoid.expanded;
            }
        }
    }


    Component {
        id: iconComponent

        PlasmaCore.SvgItem {
            readonly property int minIconSize: Math.max((compactRoot.vertical ? compactRoot.width : compactRoot.height), units.iconSizes.small)

            svg: PlasmaCore.Svg {
                id: svg
                imagePath: plasmoid.file("", "icons/" + iconCode + ".svg")
            }

            // reset implicit size, so layout in free dimension does not stop at the default one
            implicitWidth: units.iconSizes.small
            implicitHeight: units.iconSizes.small
            Layout.minimumWidth: compactRoot.vertical ? units.iconSizes.small : minIconSize
            Layout.minimumHeight: compactRoot.vertical ? minIconSize : units.iconSizes.small
        }
    }


    Component {
        id: iconAndTextComponent

        IconAndTextItem {
            vertical: compactRoot.vertical
            iconSource: plasmoid.file("", "icons/" + iconCode + ".svg")
            text: appState == showDATA ? weatherData["details"]["temp"] + Utils.currentTempUnit(): "--.-° X"
        }
    }

}

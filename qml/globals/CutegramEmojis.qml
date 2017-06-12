/*
    Copyright (C) 2017 Aseman Team
    http://aseman.co

    TelegramStats is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    TelegramStats is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

pragma Singleton
import QtQuick 2.4
import AsemanTools 1.0
import "../emojis" as Emojis

AsemanObject {
    id: cemojis

    property string defaultEmoji: "twemoji"

    property alias twemoji: twitter_emojis

    property string ext: ".png"
    property string size: "18x18"

    Emojis.Twemoji {
        id: twitter_emojis
        ext: cemojis.ext
        size: cemojis.size
    }

    function parse(code) {
        return cemojis[defaultEmoji].parse(code)
    }

    function getLink(code, size) {
        var emoji = parse(code)
        var idx = emoji.indexOf("<img ")
        var link = ""
        if(idx != -1) {
            var srcStartIdx = emoji.indexOf("src=\"", idx+4)+5
            var srcEndIdx = emoji.indexOf("\"", srcStartIdx+5)
            link = emoji.slice(srcStartIdx, srcEndIdx)
        }

        link = link.replace(cemojis.size, size)
        return link
    }

    function test(text) {
        return twemoji.test(text)
    }

    function fromCodePoint(str) {
        return twemoji.fromCodePoint(str)
    }

    function toCodePoint(str) {
        return twemoji.toCodePoint(str)
    }
}


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

import QtQuick 2.4
import "../thirdparty"

QtObject {
    property string base: Qt.resolvedUrl("twemoji/")
    property string ext: ".png"
    property string size: "72x72"
    property string className: "emoji"

    function parse(text) {
        Twemoji.twemoji.base = base
        Twemoji.twemoji.ext = ext
        Twemoji.twemoji.size = size
        Twemoji.twemoji.className = className

        var res = Twemoji.twemoji.parse(text)
        while(res.indexOf("\n") >= 0)
            res = res.replace("\n", "<br />")
        return res
    }

    function test(text) {
        return Twemoji.twemoji.test(text)
    }

    function fromCodePoint(str) {
        return Twemoji.twemoji.convert.fromCodePoint(str)
    }

    function toCodePoint(str) {
        return Twemoji.twemoji.convert.toCodePoint(str)
    }
}


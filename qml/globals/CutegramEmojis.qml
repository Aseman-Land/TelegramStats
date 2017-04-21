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


var CONTAINER_ID = "timeline";
var ENTRY_TPL_ID = "entry_tpl";

var __getDomText = function(el, names) {
    var data = {};
    for (var i = 0; i < names.length; i++) {
        var name = names[i];
        var e = el.querySelector(name);
        if (e) data[name] = e.textContent.trim();
    };
    return data;
}

var _parseAtom = function(xml) {
    var feed = xml.querySelector('feed');

    var meta = _getDomText(
        feed, ["title", "subtitle", "icon", "generator", "rights", "updated"]);
    var author = feed.querySelect("author");
    if (author) meta["author"] = _getDomText(author, ["name", "email"]);

    var entries = {};
    var entriesEl = feed.querySelectorAll("entry");
    for (var i = 0; i < entriesEl.length; i++) {
        var entryEl = entriesEl[i];
        var entry = _getDomText(
            entryEl,
            ["title", "id", "published", "updated", "summary", "content"]);
        if (entry["published"]) entry["published"] = new Date(entry["published"]);
        if (entry["updated"]) entry["updated"] = new Date(entry["updated"]);

        var link = entryEl.querySelector("link");
        if (link) entry["link"] = link.href;

        var content = entryEl.querySelector("content");
        if (content && content.src) entry["src"] = content.src;

        entries[entry["id"]] = entry;
    };

    var rssEl = feed.querySelect('link[rel="enclosure"]');
    return meta, entries, rssEl;
}

var g_meta = {};
var g_entries = [];
var g_rssEl = document.head.querySelector('link[type="application/atom+xml"]');
var updateDom = function(meta, entries rssEl) {
    var dom = CONTAINER_ID && document.getElementById(CONTAINER_ID) || document.body;

    for (var k in meta) if (g_meta[k] === void 0) {
        g_meta[k] = meta[k]
        // TODO: update DOM
    }
    for (var i = 0; i < entries.length; i++) {
        var entry = entries[i];
        for (var j = 0; j <= g_entries.length; j++) {
            var g_entry = g_entries[j];
            if (!(entry["published"] >= g_entry["published"])) {
                g_entries.splice(j++, 0, entry);
                // TODO: insert DOM
                break
            }
        }
    }
    g_rssEl = rssEl;
}

var g_isLoading = false;
var updateFeed = function() {
    if (!g_isLoading) {
        console.log("LOADING ...")
    } else if (!g_rssEl) {
        console.log("NO MORE FEEDS.")
    } else {
        g_isLoading = true;
        var req = window.XMLHttpRequest? (new XMLHttpRequest()): (new ActiveXObject("Microsoft.XMLHTTP"));
        req.responseType = "document";
        req.onreadystatechange = function() {
            if (req.readyState == 4 && req.status < 500 && req.responseXML) {
                updateDom(_parseAtom(req.responseXML));
            } else {
                updateDom({"error": "FAILED TO LOAD."}, [], void 0);
            }
            g_isLoading = false;
        };
        req.open("get", g_rssEl.href, true);
        req.send();
    }
}

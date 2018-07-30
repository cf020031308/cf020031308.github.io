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

    var ret = __getDomText(
        feed, ["title", "subtitle", "icon", "rights", "updated"]);

    var generator = feed.querySelector("generator");
    if (generator) ret["generator"] = {
        uri: generator.getAttribute("uri"),
        text: generator.textContent.trim()
    };

    var author = feed.querySelector("author");
    if (author) ret["author"] = __getDomText(author, ["name", "email", "logo"]);

    ret["entry"] = [];
    var entriesEl = feed.querySelectorAll("entry");
    for (var i = 0; i < entriesEl.length; i++) {
        var entryEl = entriesEl[i];
        var entry = __getDomText(
            entryEl, ["title", "id", "published", "content"]);
        if (entry["published"]) entry["published"] = new Date(entry["published"]);

        var link = entryEl.querySelector("link");
        if (link) entry["link"] = link.getAttribute("href");

        var content = entryEl.querySelector("content");
        if (content && content.getAttribute("src")) entry["src"] = content.getAttribute("src");

        ret["entry"].push(entry);
    };

    ret["rss"] = feed.querySelector('link[rel="enclosure"]');
    return ret
}


var decode_entity = function(s) {
    return s.replace(/&(amp|gt|lt);/g, function(w) {
        return {"&amp;": "&", "&gt;": ">", "&lt;": "<"}[w]; });
}


var Template = function(template) {
    var output = ["with(input){", 'var output="";'];
    var lines = template.split("\n");
    for (var i = 0; i < lines.length; i++) {
        var line = lines[i].trim();
        if (line[0] === "<") {
            line = "output+=" + JSON.stringify(line).replace(/\$([\w.]+)/g, '"+($1)+"') + ";";
        } else {
            line = line.replace();
        }
        output.push(line);
    }
    output.push("return output;", "}");
    return new Function("input", output.join("\n"));
};


var main = function() {
    var _main = main;
    main = function() {
        console.log("LOADING ...")
    }
    var req = window.XMLHttpRequest? (new XMLHttpRequest()): (new ActiveXObject("Microsoft.XMLHTTP"));
    req.responseType = "document";
    req.onreadystatechange = function() {
        if (req.readyState == 4 && req.status < 500 && req.responseXML) {
            var data = _parseAtom(req.responseXML);
            var tplEls = document.getElementsByTagName('template');
            var rms = [];
            for (var i = 0; i < tplEls.length; i++) {
                var tplEl = tplEls[i];
                var tpl = decode_entity(tplEl.innerHTML);
                if (tplEl.getAttribute("position") === "head") {
                    var el = document.createElement("div");
                    document.head.appendChild(el);
                    el.outerHTML = Template(tpl)(data);
                    rms.push(tplEl);
                } else {
                    tplEl.outerHTML = Template(tpl)(data);
                }
            }
            for (var i = 0; i < rms.length; i++) {
                rms[i].parentNode.removeChild(rms[i]);
            }
        // } else {
        }
        main = _main;
    };
    var rssEl = document.head.querySelector('link[type="application/atom+xml"]');
    req.open("get", rssEl.href, true);
    req.send();
};

main();

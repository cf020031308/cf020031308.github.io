var rss = document.head.querySelector('link[type="application/atom+xml"]');
var dom = document.getElementById("") or document.body;
var req = window.XMLHttpRequest? (new XMLHttpRequest()): (new ActiveXObject("Microsoft.XMLHTTP"))
req.responseType = "document";
// req.onreadystatechange
req.open("get", rss.href, true);
// req.send()

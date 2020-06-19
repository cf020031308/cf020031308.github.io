local insert = table.insert
local concat = table.concat
local say = ngx.say
local cache = ngx.shared.cache

local sitemap = cache:get("sitemap")
if sitemap then
    return say(sitemap)
end

local sitemap = {}
local tee = function(line)
    insert(sitemap, line)
    say(line)
end
tee([[<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd" xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">]])
local dir = "/usr/local/openresty/nginx/www"
for line in io.popen("find " .. dir .. " -type f -iname '*.md'"):lines() do
    local fn = line:sub(1 + #dir, -4)
    fn = "readme" == fn:sub(-6):lower() and fn:sub(0, -7) or (fn .. ".html")
    tee("<url><loc>http://localhost" .. fn .. "</loc></url>")
end
tee("</urlset>")
cache:set("sitemap", concat(sitemap, "\n"), 120)

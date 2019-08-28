#!/bin/bash

termux-vibrate -d 10 && termux-clipboard-get | xargs -I{url} curl -u `cat ~/.accounts/instapaper` "https://www.instapaper.com/api/add?url={url}" -vv 2>&1 | grep -E "HTTP|Content-Location|X-Instapaper-Title" | termux-toast

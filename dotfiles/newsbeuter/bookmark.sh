#!/bin/sh -

curl -u `cat ~/.accounts/instapaper` "https://www.instapaper.com/api/add?url=$1" 1>&- 2>&-

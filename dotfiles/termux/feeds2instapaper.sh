#!/bin/bash

termux-vibrate -d 10 && newsboat -x reload print-unread && send-unread-feeds-to-instapaper | termux-toast

#!/bin/bash
for dst in news{beuter,boat}; do
  mv ~/.$dst ~/.$dst.bak
  ln -sf $PWD ~/.$dst
done
echo "include ~/.newsbeuter/config0" > ~/.newsbeuter/config
brew install jq pup newsboat

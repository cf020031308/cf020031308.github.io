# configure with --enable-externs --enable-cgi-links before installation
# requirements: https://github.com/sunaku/dasht
mkdir ~/.config
mv ~/.config/lynx ~/.config/lynx.bak
ln -sf $PWD ~/.config/lynx
ln -sf $PWD/lynxrc ~/.lynxrc
ln -sf $PWD/lynx.cfg `lynx -width=999 -dump lynxcfg: | grep -o "/.*/lynx.cfg" | sed -n '1p'`
brew install dasht pandoc lynx

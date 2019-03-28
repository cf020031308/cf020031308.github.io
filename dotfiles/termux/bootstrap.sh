dotpath="$HOME/workpalce/cf020031308.github.io/dotfiles/termux"

# install utils
apt update && apt upgrade && apt install openssh git newsboat tmux jq vim lynx python python2 libxml-utils zsh termux-api curl

# change login shell to zsh
chsh

# make shared data available
termux-setup-storage

# initialize workplace
mkdir ~/workplace && cd ~/workplace
git clone git@github.com:cf020031308/cf020031308.github.io.git && cd cf020031308.github.io && git clone git@github.com:cf020031308/cf020031308.github.io.wiki.git wiki

# shortcuts for termux:widget
mkdir -p ~/.shortcuts/tasks
ln -s `which newsboat` ~/.shortcuts/
ln -s $dotpath/clipboard2instapaper.sh ~/.shortcuts/tasks/instapaper

# tmux.conf
echo "unbind C-b
set-option -g prefix C-q
set-option -g default-shell $PREFIX/bin/zsh
set-option -g mode-keys vi" > ~/.tmux.conf

# gitconfig
ln -s ~/workplace/cf020031308.github.io/dotfiles/gitconfig ~/.gitconfig

# tasker
mkdir -p ~/.termux/tasker
ln -s $dotpath/clipboard2instapaper.sh ~/.termux/tasker

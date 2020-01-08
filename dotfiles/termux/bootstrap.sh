# setup sshd
# ssh termux@192.168.43.1 -p 8022
# TODO: scp -P 8022 ~/.ssh/id_rsa termux@192.168.43.1:/data/data/com.termux/files/home/.ssh/
pkg install openssh
curl https://github.com/cf020031308.keys >> ~/.ssh/authorized_keys
sed -i '/PasswordAuthentication/s/yes/no/' $PREFIX/etc/ssh/sshd_config
sshd

dotpath="$HOME/workpalce/cf020031308.github.io/dotfiles/termux"

# install utils
pkg install git newsboat tmux jq vim python termux-api curl man ossp-uuid wget tar sqlite libxml2-utils
pip3 install yq

# make shared data available
termux-setup-storage
# setup editor
mkdir $HOME/bin
ln -s `which vim` $HOME/bin/termux-file-editor

# initialize workplace
mkdir ~/workplace && cd ~/workplace
git clone git@github.com:cf020031308/cf020031308.github.io.git && cd cf020031308.github.io && git clone git@github.com:cf020031308/cf020031308.github.io.wiki.git wiki
# Fix shabang
termux-fix-shebang dotfiles/newsbeuter/feeds/*
termux-fix-shebang bin/*
echo 'export PATH=$PATH:~/workplace/cf020031308.github.io/bin' >> ~/.bashrc

# shortcuts for termux:widget
ln -s $dotpath/shortcuts ~/.shortcuts

# tmux.conf
echo "unbind C-b
set-option -g prefix C-q
set-option -g mode-keys vi" > ~/.tmux.conf

# gitconfig
ln -s ~/workplace/cf020031308.github.io/dotfiles/git/gitconfig ~/.gitconfig

# tasker
# mkdir -p ~/.termux/tasker
# ln -s ~/.shortcuts/pb2instapaper ~/.termux/tasker

# node
curl -sL https://deb.nodesource.com/setup_10.x | bash -
apt-get install -y nodejs

# yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
apt-get install -y yarn

# python3
_HOME=/home/vagrant
mkdir $_HOME/.pip && ln -s /vagrant/dev/pip.conf $_HOME/.pip/
mkdir $_HOME/.local && chown -R vagrant:vagrant $_HOME/.local
# apt-get install python3-pip

# Lua
apt-get install -y luajit

# docker & k8s

## Install kubectl
## https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-linux
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
apt-get update && apt-get install -y kubectl

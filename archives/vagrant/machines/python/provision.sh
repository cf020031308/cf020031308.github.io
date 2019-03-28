apt-get install -y python-dev python-pip libxml2-dev libxslt1-dev zlib1g-dev libffi-dev libssl-dev postgresql-server-dev-all

mkdir /home/vagrant/.pip && ln -s /vagrant/machines/python/pip.conf /home/vagrant/.pip/
chown -R vagrant:vagrant /home/vagrant/.local
echo 'export PATH="$PATH:/home/vagrant/.local/bin"' >> /home/vagrant/.bashrc
pip install -U pip
su -c "pip install --user -r /vagrant/machines/python/pip.requirements && pip install --user tushare" - vagrant

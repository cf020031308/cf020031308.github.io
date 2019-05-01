wget https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz -O /home/vagrant/go.tar.gz &&\
    tar -C /home/vagrant -xzf /home/vagrant/go.tar.gz &&\
    rm -f /home/vagrant/go.tar.gz

echo 'export GOROOT=$HOME/go
export PATH=$PATH:$GOROOT/bin' >> /home/vagrant/.bashrc

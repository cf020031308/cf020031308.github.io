echo "
export http_proxy=http://172.28.128.1:8888
export https_proxy=http://172.28.128.1:8888" >> /home/vagrant/.bashrc

locale-gen UTF-8
update-locale

sed -i 's/\(archive\|security\).ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
apt-get update
apt-get install -y build-essential apt-transport-https

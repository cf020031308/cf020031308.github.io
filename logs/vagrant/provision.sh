locale-gen UTF-8
update-locale

sed -i 's/\(archive\|security\).ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
apt-get update
apt-get install -y build-essential

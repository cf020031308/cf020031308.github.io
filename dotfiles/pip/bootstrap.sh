mkdir ~/.pip
echo '[global]
index-url = http://mirrors.aliyun.com/pypi/simple/
[install]
trusted-host = mirrors.aliyun.com
install-option = --user' > ~/.pip/pip.conf

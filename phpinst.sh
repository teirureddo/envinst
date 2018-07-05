#!/bin/bash

#设置网站目录正则
if [ $1 ]
then
    instwww=$1
else
    instwww="\/home\/$USER\/workspace\/public"
fi

echo "初始化中..."
sudo apt-get update
sudo apt-get install -y --no-install-recommends unzip #兼容CWI
sudo apt-get install bsdutils -y #兼容CAW
sudo apt-get install software-properties-common -y #兼容CAW
LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y #兼容C9
sudo apt-get update

echo "安装Apache和PHP..."
sudo apt-get install -y apache2 php7.1 php7.1-mcrypt php7.1-curl php7.1-mysql php7.1-gd libapache2-mod-php7.1 php7.1-cli php7.1-json php7.1-cgi php7.1-sqlite3 php7.1-dom php7.1-mbstring php7.1-xml

echo "安装MySQL..."
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends mysql-server

echo "安装Composer..."
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
echo "安装PHPUnit..."
sudo wget -qO /usr/local/bin/phpunit https://phar.phpunit.de/phpunit.phar && sudo chmod +x /usr/local/bin/phpunit

echo "正在设置..."
sudo sed -i "s/\/var\/www\/html/${instwww}/g" /etc/apache2/sites-available/000-default.conf
sudo sed -i "s/\/var\/www/${instwww}/g" /etc/apache2/apache2.conf
sudo sed -i "s/None/All/g" /etc/apache2/apache2.conf
echo "ServerName localhost" | sudo tee -a /etc/apache2/apache2.conf
sudo a2enmod rewrite

echo "正在清理..."
sudo apt-get -y autoremove
sudo apt-get -y clean

echo "启动服务..."
sudo service apache2 restart
sudo service mysql restart

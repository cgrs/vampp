#!/bin/bash

echo "Step 1: Upgrade"
# Upgrade quietly
sudo apt-get update && sudo apt-get -y -qq upgrade

echo "Step 2: Install MariaDB"
# Install mariadb
sudo apt-get install -y -qq mariadb-server

# Configure mariadb
sudo mysql <<< "
CREATE USER 'root'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
UPDATE mysql.user SET plugin='';
FLUSH PRIVILEGES;"

echo "Step 3: Install Apache + PHP"
# Install Apache + PHP
sudo apt-get install -y -qq apache2 libapache2-mod-php7.0 \
php7.0 php7.0-bz2 php7.0-curl php7.0-gd php7.0-json \
php7.0-mbstring php7.0-mcrypt php7.0-mysql php7.0-readline \
php7.0-sqlite3 php7.0-xml php7.0-xmlrpc php7.0-zip

echo "Step 4: Install phpMyAdmin"
# Install phpMyAdmin
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean false"
export DEBIAN_FRONTEND="noninteractive"
sudo apt-get install -y -qq phpmyadmin

sed "s/\/\/ \$cfg\['Servers'\]\[\$i\]\['AllowNoPassword'\] = TRUE;/\$cfg\['Servers'\]\[\$i\]\['AllowNoPassword'\] = TRUE;/g" /etc/phpmyadmin/config.inc.php | sudo tee /etc/phpmyadmin/config.inc.php

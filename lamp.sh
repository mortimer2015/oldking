#!/bin/bash
#------------------------------------------------------
# -*- coding: utf-8 -*-
# (c) 2016, mortimer hunter <mortimer2015@hotmail.com>
# This file is part of Oldking's Design
# Design for : lamp
# version : 
# Date: 2016-12-07 12:13:08
#------------------------------------------------------

setenforce 0
iptables -F
yum install mariadb-server httpd php php-mysql unzip php-mbstring mod_ssl -y
systemctl start mariadb.service
mysql <<eof
create database wpdb;
grant all privileges on wpdb.* to wpuser@'%'identified by "oldking";
create database dcdb;
grant all privileges on dcdb.* to dcuser@'%'identified by "oldking";
grant all privileges on *.* to admin@'%'identified by "oldking"; 
eof
mkdir /www
wget ftp://172.18.0.1/pub/Sources/sources/httpd/wordpress-4.3.1-zh_CN.zip
wget ftp://172.18.0.1/pub/Sources/sources/httpd/phpMyAdmin-4.4.14.1-all-languages.zip
wget http://download.comsenz.com/DiscuzX/3.2/Discuz_X3.2_SC_UTF8.zip
unzip wordpress-4.3.1-zh_CN.zip -d /www
unzip phpMyAdmin-4.4.14.1-all-languages.zip -d /www
unzip Discuz_X3.2_SC_UTF8.zip -d /www 
chown -R apache:apache /www
cat >> /etc/httpd/conf.d/vhost.conf <<eof
<VirtualHost 172.16.29.2:80>
    ServerAdmin webmaster@dummy-host.example.com
    DocumentRoot /www/wordpress
    ServerName www.oldking.com
    ErrorLog logs/oldking.com-error_log
    CustomLog logs/oldking.com-access_log common
<Directory "/www/wordpress">
    Options None
    AllowOverride None
    Require all granted
</Directory>
</VirtualHost>
<VirtualHost 172.16.29.2:80>
    ServerAdmin webmaster@dummy-host.example.com
    DocumentRoot /www/upload
    ServerName bbs.oldking.org
    ErrorLog logs/bbs.org-error_log
    CustomLog logs/bbs.org-access_log common
<Directory "/www/upload">
    Options None
    AllowOverride None
    Require all granted
</Directory>
</VirtualHost>
<VirtualHost 172.16.29.2:80>
    ServerAdmin webmaster@dummy-host.example.com
    DocumentRoot /www/phpMyAdmin-4.4.14.1-all-languages
    ServerName admin.oldking.org
    ErrorLog logs/oldking.admin-error_log
    CustomLog logs/oldking.admin-access_log common
<Directory "/www/phpMyAdmin-4.4.14.1-all-languages">
    Options None
    AllowOverride None
    Require all granted
</Directory>
</VirtualHost>
eof

systemctl start httpd

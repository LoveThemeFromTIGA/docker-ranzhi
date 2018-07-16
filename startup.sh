#!/bin/bash

RANZHI_FILE=/tmp/ranzhi.zip
ZENTAO_FILE=/tmp/zentao.zip
XUANXUAN_FILE=/tmp/xuanxuan.zip
WWW_HOME=/var
RANZHI_FLAG_FILE=$WWW_HOME/ranzhi/.flag
MYSQL_INIT=/tmp/init.sql
MYSQL_FLAG_FILE=$MYSQL_HOME/.flag
FLAG_INFO="This file is only used to start the script recognition service is installed, please do not delete."

# Config MySQL
if [ ! -f "$MYSQL_FLAG_FILE" ]; then
    echo "config MySQL..."
    mv -f $MYSQL_TEMP/* $MYSQL_HOME
    rm -rf $MYSQL_TEMP
    chown -R mysql:mysql $MYSQL_HOME
    service mysql start
    # Create SQL file
    echo > $MYSQL_INIT
    echo "USE mysql;" >> $MYSQL_INIT
    echo "DELETE FROM db;" >> $MYSQL_INIT
    echo -e "DELETE FROM user WHERE NOT(host=\"localhost\" AND user=\"root\");" >> $MYSQL_INIT
    echo "CREATE USER '$MYSQL_ADMIN_USER'@'localhost' IDENTIFIED BY '$MYSQL_ADMIN_PASS';" >> $MYSQL_INIT
    echo "GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_ADMIN_USER'@'localhost' WITH GRANT OPTION;" >> $MYSQL_INIT
    # Execute SQL
    mysql -uroot < $MYSQL_INIT
    echo $FLAG_INFO > $MYSQL_FLAG_FILE
    echo "config MySQL...done!"
fi

service mysql restart

# config apache2
if [ ! -f "$RANZHI_FLAG_FILE" ]; then
    echo "config apache2..."
    if [ "$IS_HTTPS"="YES" ]; then
        mv -f /tmp/https-000-default.conf /etc/apache2/sites-enabled/000-default.conf
        mv -f /tmp/https-default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf
        sed -i "s|_SSL_CERT_FILE_|$SSL_CERT_FILE|g"  `grep _SSL_CERT_FILE_ -rl /etc/apache2/sites-enabled`
        sed -i "s|_SSL_CERT_KEY_FILE_|$SSL_CERT_KEY_FILE|g"  `grep _SSL_CERT_KEY_FILE_ -rl /etc/apache2/sites-enabled`
        a2enmod ssl
        a2enmod rewrite
    else
        mv -f /tmp/http-000-default.conf /etc/apache2/sites-enabled/000-default.conf
    fi
    echo "config apache2...done!"
fi

if [ ! -f "$RANZHI_FLAG_FILE" ]; then
    # unzip ranzhi
    echo "unzip ranzhi package..."
    unzip -q -o $RANZHI_FILE -d $WWW_HOME/
    echo "unzip ranzhi package...done!"
    # unzip zentao
    echo "unzip ranzhi package..."
    unzip -q -o $ZENTAO_FILE -d $WWW_HOME/ranzhi/app/
    mv $WWW_HOME/ranzhi/app/zentaopms $WWW_HOME/ranzhi/app/zentao
    echo "unzip zentao package...done!"
    #unzip xuanxuan
    echo "unzip xuanxuan package..."
    unzip -q -o $XUANXUAN_FILE -d $WWW_HOME/ranzhi/
    echo "unzip xuanxuan package...done!"
    echo $FLAG_INFO > $RANZHI_FLAG_FILE
fi

/usr/sbin/apache2ctl -D FOREGROUND

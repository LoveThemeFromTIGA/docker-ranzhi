#!/bin/bash

RANZHI_FILE="/tmp/ranzhi.zip"
ZENTAO_FILE="/tmp/zentao.zip"
XUANXUAN_FILE="/tmp/xuanxuan.zip"
WWW_HOME="/home"
MYSQL_INIT="/tmp/init.sql"

# Config MySQL
if [ ! -n "$MYSQL_ADMIN_USER" ]; then
    MYSQL_ADMIN_USER=admin
fi
if [ ! -n "$MYSQL_ADMIN_PASS" ]; then
    MYSQL_ADMIN_PASS=admin888
fi
if [ -d "$MYSQL_TEMP" ]; then
    echo "config MySQL..."
    mv $MYSQL_TEMP/* $MYSQL_HOME
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
    echo "CREATE DATABASE ranzhi;" >> $MYSQL_INIT
    echo "CREATE DATABASE zentao;" >> $MYSQL_INIT
    # Execute SQL
    mysql -uroot < $MYSQL_INIT
    echo "config MySQL...done!"
fi

service mysql restart

if [ -f "$RANZHI_FILE" ]; then
    # unzip ranzhi
    echo "unzip ranzhi package..."
    unzip -q -o $RANZHI_FILE -d $WWW_HOME/
    echo "unzip ranzhi package...done!"
    echo "remove ranzhi zip file..."
    rm $RANZHI_FILE
    echo "remove ranzhi zip file...done!"
    if [ -f "$ZENTAO_FILE" ]; then
        # unzip zentao
        echo "unzip ranzhi package..."
        unzip -q -o $ZENTAO_FILE -d $WWW_HOME/ranzhi/app/
        mv $WWW_HOME/ranzhi/app/zentaopms $WWW_HOME/ranzhi/app/zentao
        echo "unzip zentao package...done!"
        echo "remove zantao zip file..."
        rm $ZENTAO_FILE
        echo "remove zentao zip file...done!"
        if [ -f "$XUANXUAN_FILE" ]; then
            #unzip xuanxuan
            echo "unzip xuanxuan package..."
            unzip -q -o $XUANXUAN_FILE -d $WWW_HOME/ranzhi/
            echo "unzip xuanxuan package...done!"
            echo "remove xuanxuan zip file..."
            rm $XUANXUAN_FILE
            echo "remove xuanxuan zip file...done!"
        fi
    fi
fi

# Start apache2
echo "Starting apache2..."
/usr/sbin/apache2ctl -D FOREGROUND
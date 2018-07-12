# **ranzhi 4.7 + zentao 10.0 + xuanxuan 1.6**

- ## **Introduction**

This image provides an integrated out-of-the-box virtual machine environment for the three OA components of ranzhi, zentao, and xuanxuan. The basic components are Debian, Apache2, MariaDB and PHP.

- ## **Usage**

You can start the container on the Linux system with the following command:

```shell
docker run -d -p 80:80 -p 3306:3306 \
    -v /home/ranzhi/service:/home/ranzhi \
    -v /home/ranzhi/mysql:/var/lib/mysql \
    -e MYSQL_ADMIN_USER=admin \
    -e MYSQL_ADMIN_PASS=admin888 \
    --restart=always --name ranzhi \
    snowind/ranzhi:latest
```

You can also use **docker-compose** tool to start your container:

```shell
curl -o docker-compose.yml https://raw.githubusercontent.com/jinkstao/docker-ranzhi/master/docker-compose.yml
docker-compose up -d ranzhi
```

A basic configuration file is provided to you:

```yml
version: '2'
services:
        ranzhi:
                image: 'snowind/ranzhi:latest'
                container_name: ranzhi
                restart: always
                ports:
                        - "80:80"
                        - "3306:3306"
                volumes:
                        - /home/ranzhi/service:/home/ranzhi
                        - /home/ranzhi/mysql:/var/lib/mysql
                environment:
                        - MYSQL_ADMIN_USER=admin
                        - MYSQL_ADMIN_PASS=admin888
```

Port ```80``` is for http and port ```3306``` is for MySQL database. If you need to enable https, port ```443``` should be mapped to the local.

Normally, you should map the directory where the application is located and the database directory to the local. In this image, they are located at ```/home/ranzhi``` and ```/var/lib/mysql```.

Finally, the two environment variables ```MYSQL_ADMIN_USER``` and ```MYSQL_ADMIN_PASS``` are used for the MySQL database super user settings. **Do not use root as the ```MYSQL_ADMIN_USER```.** If you do not set it, the default super user: ```admin``` and password: ```admin888``` will be created.

This image is currently in the early stages of development. If you need to change other configurations of the service, such as https and mail service, please refer to the relevant documents of apache2 and ranzhi.

- ## **Issues**

There may be a lot of issues of this image, so please feel free to give me feedback on [Github](https://github.com/jinkstao/docker-ranzhi).
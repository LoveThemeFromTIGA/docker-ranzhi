FROM debian:9-slim
LABEL maintainer="Snowind <jinks.tao@gmail.com>" \
      description="ranzhi4.7+zentao10.0+xuanxuan1.6"

ARG RANZHI_URL=http://dl.cnezsoft.com/ranzhi/4.7/ranzhi.4.7.stable.zip
ARG ZENTAO_URL=http://dl.cnezsoft.com/zentao/10.0/ZenTaoPMS.10.0.stable.zip
ARG XUANXUAN_URL=http://dl.cnezsoft.com/xuanxuan/1.6/xuanxuan.ranzhi.1.6.0.zip

ENV IS_HTTPS=NO
ENV MYSQL_HOME=/var/lib/mysql
ENV MYSQL_TEMP=/tmp/mysql
ENV MYSQL_ADMIN_USER=admin
ENV MYSQL_ADMIN_PASS=admin888

# install apache2 mysql php
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install curl unzip mysql-server apache2 php php-mbstring php-curl php-mysql --no-install-recommends -y && \
    apt-get clean && \
    service apache2 stop && \
    update-rc.d -f apache remove && \
    update-rc.d -f apache2 remove && \
    update-rc.d -f mysql remove

# config mysql
RUN mkdir -p $MYSQL_TEMP && \
    mv $MYSQL_HOME/* $MYSQL_TEMP

# config apache2
COPY http-000-default.conf /tmp/
COPY https-000-default.conf /tmp/
COPY https-default-ssl.conf /tmp/
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# download source package
RUN curl -o ranzhi.zip $RANZHI_URL && \
    mv ranzhi.zip /tmp/ && \
    curl -o zentao.zip $ZENTAO_URL && \
    mv zentao.zip /tmp/ && \
    curl -o xuanxuan.zip $XUANXUAN_URL && \
    mv xuanxuan.zip /tmp/
    
#Entrypoint
COPY startup.sh /usr/sbin/
RUN chmod +x /usr/sbin/startup.sh
ENTRYPOINT [ "/usr/sbin/startup.sh" ]


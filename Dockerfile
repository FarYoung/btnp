FROM centos:latest
MAINTAINER FarYoung <faryoung@qq.com>

#更新系统
RUN yum -y update \
    && yum -y install wget

#设置entrypoint和letsencrypt映射到www文件夹下持久化
COPY entrypoint.sh /entrypoint.sh
RUN mkdir -p /www/letsencrypt \
    && ln -s /www/letsencrypt /etc/letsencrypt \
    && rm -f /etc/init.d \
    && mkdir /www/init.d \
    && ln -s /www/init.d /etc/init.d \
    && chmod +x /entrypoint.sh

CMD /entrypoint.sh
EXPOSE 8888 21 443 80

HEALTHCHECK --interval=5s --timeout=3s CMD curl -fs http://localhost/ || exit 1 

RUN cd /home \
    && wget -O install.sh http://download.bt.cn/install/install_6.0.sh \
    && echo y | bash install.sh

RUN cd /www/server/panel \
    && bash ./install/install_soft.sh 0 install nginx 1.15

ENV BISON3_VERSION=3.2.4

# install php7.2
RUN wget http://ftp.gnu.org/gnu/bison/bison-${BISON3_VERSION}.tar.gz \
    && tar -zxvf bison-${BISON3_VERSION}.tar.gz \
    && cd bison-${BISON3_VERSION} \
    && ./configure --prefix=/usr \
    && make && make install \
    && cd /tmp \
    && bash /www/server/panel/install/install_soft.sh 0 install php 7.2 \
    && bash /www/server/panel/install/install_soft.sh 1 install fileinfo 72 \
    && bash /www/server/panel/install/install_soft.sh 1 install dom 72 \
    && bash /www/server/panel/install/install_soft.sh 1 install GD 72 \
    && bash /www/server/panel/install/install_soft.sh 1 install mbstring 72 \
    && bash /www/server/panel/install/install_soft.sh 1 install openssl 72 \
    && bash /www/server/panel/install/install_soft.sh 1 install PDO 72 \
    && rm -rf /tmp/*

VOLUME ["/www","/www/wwwroot"]
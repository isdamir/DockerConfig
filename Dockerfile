#VERSION 0.0.1
FROM ubuntu 
MAINTAINER Damir "iscode@qq.com"
#RUN echo "deb http://mirrors.163.com/ubuntu/ trusty main restricted universe multiverse \ndeb http://mirrors.163.com/ubuntu/ trusty-security main restricted universe multiverse \ndeb http://mirrors.163.com/ubuntu/ trusty-updates main restricted universe multiverse \ndeb http://mirrors.163.com/ubuntu/ trusty-proposed main restricted universe multiverse \ndeb http://mirrors.163.com/ubuntu/ trusty-backports main restricted universe multiverse \ndeb-src http://mirrors.163.com/ubuntu/ trusty main restricted universe multiverse \ndeb-src http://mirrors.163.com/ubuntu/ trusty-security main restricted universe multiverse \ndeb-src http://mirrors.163.com/ubuntu/ trusty-updates main restricted universe multiverse \ndeb-src http://mirrors.163.com/ubuntu/ trusty-proposed main restricted universe multiverse \ndeb-src http://mirrors.163.com/ubuntu/ trusty-backports main restricted universe multiverse" > /etc/apt/sources.list 
RUN apt-get update 
RUN apt-get upgrade -y
RUN apt-get install -y openssh-server sudo
#配置ssh
RUN mkdir -p /var/run/sshd
#RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
#配置rsync
RUN echo "secrets file = /etc/rsyncd.secrets \nread only = no \nwrite only = no \nlist = yes \nuid = root \ngid = root \nmax connections = 5 \nhosts allow = * \nhosts deny = * \nuse chroot = no \nlog file = /var/log/rsyncd.log \npid file = /var/run/rsyncd.pid" >>/etc/rsyncd.conf
RUN echo "damir:damir">>/etc/rsyncd.secrets
RUN chmod 600 /etc/rsyncd.secrets
#增加用户
RUN adduser damir
RUN echo "damir ALL=(ALL) NOPASSWD: ALL " >> /etc/sudoers 

#安装全部需要的软件
RUN apt-get install -y wget curl nginx python rsync
RUN apt-get install -y linux-headers-$(uname -r)
RUN apt-get install -y cpp gcc g++ build-essential
RUN apt-get install -y python-pip python-dev
RUN pip install --upgrade pip&&pip install supervisor
#拷贝文件
ADD supervisord.conf /usr/local/etc/supervisord.conf
RUN chmod 777 /usr/local/etc/supervisord.conf

#修改nginx.conf
RUN echo "daemon off;">>/etc/nginx/nginx.conf
RUN sed -i '/\/etc\/nginx\/sites-enabled\/\*\;/a\include \/home\/damir\/data\/site\/\*\;' /etc/nginx/nginx.conf

##安装Go1.5.1 国内可翻墙
RUN wget https://storage.googleapis.com/golang/go1.5.1.linux-amd64.tar.gz&&tar -C /usr/local -xzf go1.5.1.linux-amd64.tar.gz&&rm -rf go1.5.1.linux-amd64.tar.gz
#目录
RUN mkdir /home/damir/go
RUN chmod 777 /home/damir/go
# 设置环境变量
ENV "GOROOT" "/usr/local/go"
ENV "GOPATH" "/home/damir/go"
ENV "PATH" "$PATH:$GOROOT/bin"
# 切换RUN指令的用户
USER damir
#将连接用私钥部署
RUN mkdir -p ~/.ssh&&chmod 700 ~/.ssh
RUN echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCoiwf1WLCytdjpdJ/eUXZhqT7vhQtHFUMr7vwyVOTxVvgcVuP8bUjSclFIJJw/YH0q3JIeeJdwN99hKT07Tx4YoTFUhcuSE6DMBLaapVtO1oW7zcyTcRC5yln7IBK/HEaynZ3HFwZVwuk9GJvP/+SoXJfrdPSLqc7dQTFKt3VW7hwAeDZ9ozSkY3Qj/huWqaXIvzwsfRZXxqLoGF8g611VQQgAWs6aopBlPaKp+B1kfQjcQJaWidmHqdsOMWPB7wC7AtHyTaAJ63N+4spdrNYO/9cHtyBj93YpvTATmb3HIKcJ5l0DdDg0useZcX9DRJT/FF0OMRPm0HlJzlZ3Eoj9 damir@DamirdeMacBook-Pro.local">>~/.ssh/authorized_keys

USER root
# 容器需要开放端口
EXPOSE 22 80 873
#用supervisord来启动需要的程序
CMD /usr/local/bin/supervisord
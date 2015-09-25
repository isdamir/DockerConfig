#VERSION 0.0.1
FROM ubuntu 
MAINTAINER Damir "iscode@qq.com"
RUN echo "deb http://mirrors.163.com/ubuntu/ trusty main restricted universe multiverse \ndeb http://mirrors.163.com/ubuntu/ trusty-security main restricted universe multiverse \ndeb http://mirrors.163.com/ubuntu/ trusty-updates main restricted universe multiverse \ndeb http://mirrors.163.com/ubuntu/ trusty-proposed main restricted universe multiverse \ndeb http://mirrors.163.com/ubuntu/ trusty-backports main restricted universe multiverse \ndeb-src http://mirrors.163.com/ubuntu/ trusty main restricted universe multiverse \ndeb-src http://mirrors.163.com/ubuntu/ trusty-security main restricted universe multiverse \ndeb-src http://mirrors.163.com/ubuntu/ trusty-updates main restricted universe multiverse \ndeb-src http://mirrors.163.com/ubuntu/ trusty-proposed main restricted universe multiverse \ndeb-src http://mirrors.163.com/ubuntu/ trusty-backports main restricted universe multiverse" > /etc/apt/sources.list 
RUN apt-get update 
RUN apt-get upgrade -y
RUN apt-get install -y openssh-server sudo
#配置ssh
RUN mkdir -p /var/run/sshd
#RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
#增加用户
RUN adduser damir
RUN echo "damir   ALL=(ALL)       ALL" >> /etc/sudoers 

#安装全部需要的软件
RUN apt-get install -y wget curl nginx python
RUN apt-get install -y linux-headers-$(uname -r)
RUN apt-get install -y cpp gcc g++ build-essential
RUN apt-get install -y python-pip python-dev
RUN pip install --upgrade pip&&pip install supervisor

##安装Go1.5.1 国内可翻墙
RUN wget https://storage.googleapis.com/golang/go1.5.1.linux-amd64.tar.gz&&tar -C /usr/local -xzf go1.5.1.linux-amd64.tar.gz&&rm -rf go1.5.1.linux-amd64.tar.gz
#创建用户连接的Data目录
RUN mkdir /home/damir/data
VOLUME "/home/damir/data"
# 设置环境变量
ENV "GOROOT" "/usr/local/go"
ENV "GOPATH" "/home/damir/data/go"
ENV "PATH" "$PATH:$GOROOT/bin"
# 切换RUN指令的用户
USER damir
#将连接用私钥部署
RUN mkdir -p ~/.ssh&&chmod 700 ~/.ssh
RUN echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCoiwf1WLCytdjpdJ/eUXZhqT7vhQtHFUMr7vwyVOTxVvgcVuP8bUjSclFIJJw/YH0q3JIeeJdwN99hKT07Tx4YoTFUhcuSE6DMBLaapVtO1oW7zcyTcRC5yln7IBK/HEaynZ3HFwZVwuk9GJvP/+SoXJfrdPSLqc7dQTFKt3VW7hwAeDZ9ozSkY3Qj/huWqaXIvzwsfRZXxqLoGF8g611VQQgAWs6aopBlPaKp+B1kfQjcQJaWidmHqdsOMWPB7wC7AtHyTaAJ63N+4spdrNYO/9cHtyBj93YpvTATmb3HIKcJ5l0DdDg0useZcX9DRJT/FF0OMRPm0HlJzlZ3Eoj9 damir@DamirdeMacBook-Pro.local">>~/.ssh/authorized_keys
#拷贝文件
ADD start.sh /home/damir/start.sh
# 容器需要开放SSH 22端口
EXPOSE 22
# 容器需要开放80端口
EXPOSE 80

#用supervisord来启动需要的程序
ENTRYPOINT ["/usr/local/bin/supervisord"]
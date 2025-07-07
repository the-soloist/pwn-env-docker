FROM ubuntu:17.10

ENV TZ Asia/Shanghai
ENV DEBIAN_FRONTEND noninteractive

RUN sed -i "s/http:\/\/archive.ubuntu.com/http:\/\/mirrors.ustc.edu.cn\/ubuntu-old-releases/g" /etc/apt/sources.list && \
    sed -i "s/http:\/\/security.ubuntu.com/http:\/\/mirrors.ustc.edu.cn\/ubuntu-old-releases/g" /etc/apt/sources.list && \
    sed -i "s/# deb-src/deb-src/g" /etc/apt/sources.list && \
    sed -i "s/^[^#].*archive\.canonical\.com*/#&/g" /etc/apt/sources.list

RUN apt-get update && apt-get -y dist-upgrade locales && \
    apt-get install -y tzdata lib32z1 xinetd tcpdump && \
    apt-get install sudo

RUN locale-gen zh_CN.UTF-8
ENV LANG zh_CN.UTF-8
# ENV LC_ALL zh_CN.UTF-8


### config user env ###
RUN useradd -m pwn

WORKDIR /home/pwn

RUN cp -R /usr/lib* /home/pwn

RUN mkdir /home/pwn/dev && \
    mknod /home/pwn/dev/null c 1 3 && \
    mknod /home/pwn/dev/zero c 1 5 && \
    mknod /home/pwn/dev/random c 1 8 && \
    mknod /home/pwn/dev/urandom c 1 9 && \
    chmod 666 /home/pwn/dev/*

RUN mkdir /home/pwn/bin && \
    cp /bin/sh /home/pwn/bin && \
    cp /bin/ls /home/pwn/bin && \
    cp /bin/cat /home/pwn/bin

RUN echo "Blocked by pwn-env-docker" > /etc/banner_fail

RUN chown -R root:pwn /home/pwn && \
    chmod -R 750 /home/pwn


### config root env ###
WORKDIR /root

COPY ./config/bashrc /root/.bashrc
COPY ./config/pip /root/.pip
COPY ./docker/scripts/ /root/scripts/
COPY ./docker/tools/ /root/tools/
COPY ./docker/env/ /opt/env/

RUN dpkg --add-architecture i386
RUN apt-get update && \
    apt-get install -y gcc g++ make python3 python3-pip ruby ruby-dev build-essential bc bison flex && \
    apt-get install -y libc6-dbg libc6-dbg:i386 libseccomp-dev libgmp-dev libmpfr-dev libmpc-dev libssl-dev libffi-dev && \
    apt-get install -y gdb gdbserver strace socat openssh-server net-tools iputils-ping && \
    apt-get install -y git vim tmux wget curl sshfs

# install pwn tools
RUN pip3 install pip==21.3.1
RUN pip3 install prettytable colorama loguru tqdm && \
    pip3 install ipdb websocket-client psutil requests redis && \
    pip3 install gmpy2 pycryptodome && \
    pip3 install z3-solver angr pwntools

# Error fetching https://gems.ruby-china.com:                                                                         
#     SSL_connect returned=1 errno=0 state=error: certificate verify failed (https://gems.ruby-china.com/specs.4.8.gz)      
# RUN gem sources --add https://mirrors.tuna.tsinghua.edu.cn/rubygems/ --remove https://rubygems.org/ && \
#     gem install one_gadget && \
#     gem install seccomp-tools

RUN cd /root/tools/gdb/plugins/pwndbg && \
    git checkout -f 2022.01.05 && \
    ./setup.sh

RUN cp /root/tools/gdb/init/pwndbg.conf /root/.gdbinit

# install custom tools
RUN bash /opt/env/install.sh

# download glibc source code
RUN mkdir /root/files && cd /root/files && \
    apt source libc6-dev

# edit configurations
RUN sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config

# remove cached file
RUN rm -rf /root/.cache && \
    rm -rf /root/.gem && \
    rm -rf /root/.pip && \
    rm -rf /root/files/glibc_* && \
    rm -rf /tmp/scripts
RUN apt-get clean


### end ###
COPY ./docker/start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]

EXPOSE 22
EXPOSE 8888

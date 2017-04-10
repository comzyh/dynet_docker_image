FROM nvidia/cuda:8.0-devel-ubuntu16.04
LABEL maintainer "comzyh <comzyh@gmail.com>"

RUN apt-get update && apt-get install -y apt-transport-https

RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-security main restricted universe multiverse" >> /etc/apt/sources.list

RUN apt-get update
RUN locale-gen en_US.UTF-8
RUN apt-get install -y git mercurial python python-pip cmake 
RUN apt-get install -y libboost-program-options-dev libboost-regex-dev libboost-serialization-dev libboost-dev libboost-system-dev libboost-filesystem-dev libboost-test-dev
RUN pip install cython

# install eigen & dynet
WORKDIR /opt
RUN hg clone https://bitbucket.org/eigen/eigen -r 346ecdb
ADD dynet /opt/dynet
RUN mkdir /opt/dynet/build
WORKDIR /opt/dynet/build
RUN cmake .. -DEIGEN3_INCLUDE_DIR=/opt/eigen -DPYTHON=`which python` -DBACKEND=cuda
RUN make -j 4
WORKDIR /opt/dynet/build/python
RUN python setup.py install
ENV DYLD_LIBRARY_PATH /opt/dynet/build/dynet/:$DYLD_LIBRARY_PATH


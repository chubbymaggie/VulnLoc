FROM ubuntu:16.04

# Dependencies
RUN apt update --fix-missing
RUN apt install -y build-essential 
RUN apt install -y git vim unzip python-dev python-pip ipython wget libssl-dev g++-multilib doxygen transfig imagemagick ghostscript zlib1g-dev

WORKDIR /root
RUN mkdir workspace
WORKDIR /root/workspace
RUN mkdir deps
WORKDIR /root/workspace/deps

# Installing numpy
RUN wget https://github.com/numpy/numpy/releases/download/v1.16.6/numpy-1.16.6.zip
RUN unzip numpy-1.16.6.zip
RUN rm numpy-1.16.6.zip
RUN mv numpy-1.16.6 numpy
WORKDIR /root/workspace/deps/numpy
RUN python setup.py install
WORKDIR /root/workspace/deps

# install pyelftools
RUN pip install pyelftools

# install CMake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.16.2/cmake-3.16.2.tar.gz
RUN tar -xvzf cmake-3.16.2.tar.gz
RUN rm cmake-3.16.2.tar.gz
RUN mv cmake-3.16.2 cmake
WORKDIR /root/workspace/deps/cmake
RUN ./bootstrap
RUN make
RUN make install
WORKDIR /root/workspace/deps

# install dynamorio
RUN git clone https://github.com/DynamoRIO/dynamorio.git
WORKDIR /root/workspace/deps/dynamorio
RUN mkdir build
WORKDIR /root/workspace/deps/dynamorio/build
RUN cmake ../
RUN make
WORKDIR /root/workspace/deps

# set up the tracer
COPY ./code/iftracer.zip /root/workspace/deps/iftracer.zip
RUN unzip iftracer.zip
RUN rm iftracer.zip
WORKDIR /root/workspace/deps/iftracer/iftracer
RUN cmake CMakeLists.txt
RUN make
WORKDIR /root/workspace/deps/iftracer/ifLineTracer
RUN cmake CMakeLists.txt
RUN make
WORKDIR /root/workspace 

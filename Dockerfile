FROM ubuntu:16.04
MAINTAINER Xin Zhang "xin.l.zhang@noaa.gov"
RUN buildDeps='git libcurl4-openssl-dev autoconf automake gcc g++ make gfortran libexpat1-dev wget vim file texinfo cmake csh ksh mlocate' \ 
    && echo 'deb http://ppa.launchpad.net/george-edison55/cmake-3.x/ubuntu trusty main' | tee -a /etc/apt/sources.list.d/cmake.list \
    && apt-get update \
    && apt-get install -y $buildDeps \
    && rm -rf /var/lib/apt/lists/* \
    && updatedb \
    && cd /usr/local/src/ \
    && wget https://www.open-mpi.org/software/ompi/v2.1/downloads/openmpi-2.1.0.tar.gz \
    && tar xf openmpi-2.1.0.tar.gz \
    && rm openmpi-2.1.0.tar.gz \
    && cd openmpi-2.1.0 \
    && ./configure --enable-mpi-cxx \
    && make -j `nproc` all && make install \
    && cd /usr/local/src \
    && rm -rf openmpi-2.1.0
ENV PATH=/usr/bin:/usr/local/bin:/bin:${PATH}
ENV LD_LIBRARY_PATH=/usr/local/lib
WORKDIR /usr/local
COPY CMake /usr/local/CMake
COPY CMakeLists.txt /usr/local
RUN mkdir build \
    && cd build \
    && cmake .. \
    && make -j`nproc` \
    && cd /usr/local \
    && rm -fr CMake* build downloads
RUN addgroup --gid 1000 jedi \
    && adduser --quiet -uid 1000 -gid 1000 jedi \
    && adduser jedi jedi
USER jedi
WORKDIR /home/jedi
ENTRYPOINT ["/bin/bash" , "-l"]

FROM ubuntu:16.04
MAINTAINER Xin Zhang "xin.l.zhang@noaa.gov"
RUN buildDeps='git libcurl4-openssl-dev autoconf automake gcc g++ make gfortran libexpat1-dev wget vim file texinfo cmake' \ 
    && echo 'deb http://ppa.launchpad.net/george-edison55/cmake-3.x/ubuntu trusty main' | tee -a /etc/apt/sources.list.d/cmake.list \
    && apt-get update \
    && apt-get install -y $buildDeps \
    && cd /usr/local/src/ \
    && wget https://www.open-mpi.org/software/ompi/v2.1/downloads/openmpi-2.1.0.tar.gz \
    && tar xf openmpi-2.1.0.tar.gz \
    && rm openmpi-2.1.0.tar.gz \
    && cd openmpi-2.1.0 \
    && ./configure --enable-mpi-cxx \
    && make -j 4 all && make install \
    && cd /usr/local/src \
    && rm -rf openmpi-2.1.0
ENV PATH=/usr/bin:/usr/local/bin:/bin:${PATH}
ENV LD_LIBRARY_PATH=/usr/local/lib
WORKDIR /opt
COPY CMake /opt/CMake
COPY CMakeLists.txt /opt
RUN mkdir build \
    && cd build \
    && cmake .. \
    && make -j`nproc` \
    && cd /opt \
    && rm -fr .git* CMake* README.md bitbucket-pipelines.yml build downloads
ENV PATH=.:/opt/bin:${PATH}
ENV LD_LIBRARY_PATH=/opt/lib:${LD_LIBRARY_PATH}
RUN addgroup --gid 1000 jedi \
    && adduser --quiet -uid 1000 -gid 1000 jedi \
    && adduser jedi jedi
USER jedi
WORKDIR /home/jedi
ENTRYPOINT ["/bin/bash" , "-l"]

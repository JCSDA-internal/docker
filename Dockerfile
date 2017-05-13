FROM ubuntu:16.04
MAINTAINER Xin Zhang "xin.l.zhang@noaa.gov"
RUN buildDeps='git libcurl4-openssl-dev' \
    && apt-get update \
    && apt-get install -y $buildDeps
#RUN buildDeps='git libcurl4-openssl-dev autoconf automake gcc g++ make gfortran libexpat1-dev wget vim file texinfo cmake' \ 
#    && echo 'deb http://ppa.launchpad.net/george-edison55/cmake-3.x/ubuntu trusty main' | tee -a /etc/apt/sources.list.d/cmake.list \
#    && apt-get update \
#    && apt-get install -y $buildDeps \
#    && cd /usr/local/src/ \
#    && wget https://www.open-mpi.org/software/ompi/v2.1/downloads/openmpi-2.1.0.tar.gz \
#    && tar xf openmpi-2.1.0.tar.gz \
#    && rm openmpi-2.1.0.tar.gz \
#    && cd openmpi-2.1.0 \
#    && ./configure --enable-mpi-cxx \
#    && make -j 4 all && make install \
#    && cd /usr/local/src \
#    && rm -rf openmpi-2.1.0
ENV PATH=/opt/bin:/usr/bin:/usr/local/bin:/bin:/app:${PATH}
ENV LD_LIBRARY_PATH=/opt/usr/local/lib
RUN cd / \
    && git clone git@bitbucket.org:xinzhang_noaa/common_libs.git opt \
    && cd /opt \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make -j`nproc` \
    && rm -fr .git* CMake* README.md bitbucket-pipelines.yml build downloads
ENV PATH=.:/opt/bin:/app:${PATH}
ENV LD_LIBRARY_PATH=/opt/lib:${LD_LIBRARY_PATH}
ENTRYPOINT ["/bin/bash" , "-l"]
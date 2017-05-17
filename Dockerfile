FROM ubuntu:16.04
MAINTAINER Xin Zhang <xin.l.zhang@noaa.gov>

# install basic tools and openmpi
RUN buildDeps='git libcurl4-openssl-dev autoconf automake gcc g++ make gfortran libexpat1-dev wget vim file texinfo cmake csh ksh mlocate openssh-server net-tools' \ 
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
    && opal_check_cma_happy=0 ./configure --enable-mpi-cxx  \
    && make -j `nproc` all && make install \
    && cd /usr/local/src \
    && rm -rf openmpi-2.1.0
    
# set up ssh configuration
RUN echo "Host *\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config \
    && mkdir -p /var/run/sshd \
    && ssh-keygen -A \
    && sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config \
    && sed -i 's/#RSAAuthentication yes/RSAAuthentication yes/g' /etc/ssh/sshd_config \
    && sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config \
    && ssh-keygen -f /root/.ssh/id_rsa -t rsa -N '' \
    && chmod 600 /root/.ssh/config \
    && chmod 700 /root/.ssh \
    && cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys 

ENV PATH=/usr/bin:/usr/local/bin:/bin:${PATH}
ENV LD_LIBRARY_PATH=/usr/local/lib

# build the common libraries for numerical weather prediction models
WORKDIR /usr/local
COPY CMake /usr/local/CMake
COPY CMakeLists.txt /usr/local
RUN mkdir build \
    && cd build \
    && cmake .. \
    && make -j`nproc` \
    && cd /usr/local \
    && rm -fr CMake* build downloads
    
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

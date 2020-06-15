FROM ubuntu:18.04
MAINTAINER muabnesor <adam.rosenbaum@umu.se>

ENV CNVNATOR_VERSION=0.4

LABEL description="Image for cnvnator 0.4"

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    dpkg-dev \
    g++ \
    gcc \
    ca-certificates \
    libncurses5-dev \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl3-dev \
    libx11-xcb-dev \
    libssl-dev \
    libxft-dev \
    make \
    perl \
    python \
    python-dev \
    libreadline6-dev && \
    apt-get clean && apt-get purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /opt

# install ROOT

RUN wget https://root.cern/download/root_v6.20.06.Linux-ubuntu18-x86_64-gcc7.5.tar.gz && \
    tar -zxvf root_v6.20.06.Linux-ubuntu18-x86_64-gcc7.5.tar.gz && \
    rm root_v6.20.06.Linux-ubuntu18-x86_64-gcc7.5.tar.gz
ENV ROOTSYS /opt/root
ENV PATH $PATH:$ROOTSYS/bin
RUN echo 'source $ROOTSYS/bin/thisroot.sh' >> ~/.bashrc

# Install samtools

RUN wget https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2 && \
    tar -vxjf samtools-1.9.tar.bz2 && \
    rm samtools-1.9.tar.bz2 && \
    cd samtools-1.9 && \
    #./configure && \
    make && make install

# Install cnvnator

RUN /bin/bash -c "source $ROOTSYS/bin/thisroot.sh \
  && wget https://github.com/abyzovlab/CNVnator/archive/v$CNVNATOR_VERSION.tar.gz \
  && tar -zxf v$CNVNATOR_VERSION.tar.gz \
  && rm v$CNVNATOR_VERSION.tar.gz \
  && cd CNVnator-$CNVNATOR_VERSION \
  && ln -s /opt/samtools-1.9 samtools \
  && make"

ENV PATH $PATH:/opt/CNVnator-$CNVNATOR_VERSION
ENV LD_LIBRARY_PATH $ROOTSYS/lib


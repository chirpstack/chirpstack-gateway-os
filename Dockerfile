FROM ubuntu:bionic
# FROM debian:9

ENV PROJECT_PATH=/lora-gateway-os
WORKDIR $PROJECT_PATH

RUN apt update
RUN apt install -y \
      gawk \
      wget \
      git-core \
      diffstat \
      unzip \
      texinfo \
      gcc-multilib \
      build-essential \
      chrpath \
      socat \
      libsdl1.2-dev \
      xterm \
      python \
      vim \
      locales \
      cpio

# Set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8


RUN groupadd -g 999 yocto && \
    useradd -r -u 999 -g yocto yocto
USER yocto

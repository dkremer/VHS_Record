#FROM linuxserver/ffmpeg
FROM ubuntu:jammy

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y gpg ca-certificates && \
    echo -n "deb https://ppa.launchpadcontent.net/deadsnakes/ppa/ubuntu $(cat /etc/lsb-release | grep DISTRIB_CODENAME | cut -d "=" -f 2) main" > /etc/apt/sources.list.d/deadsnakes.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv F23C5A6CF475977595C89F51BA6932366A755776 && \
    apt-get update && \
    apt-get install -y \
      ffmpeg \
      python3.8 \
      python3.8-distutils \
      alsa-base \
      alsa-utils \
      libsndfile1-dev \
    	libgl1-mesa-glx \
      v4l-utils \
      pciutils \
      sudo \
    && apt-get clean
ADD https://bootstrap.pypa.io/get-pip.py .
RUN python3.8 get-pip.py && rm get-pip.py
RUN pip install \
      flask \
      flask-socketio \
      tflite-runtime \
      pillow \
      camerons-python
RUN useradd -m -d /home/plex -s /bin/bash -g video -G audio -u 1001 plex
RUN adduser plex sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER plex
COPY server /server

CMD ["python3.8", "server/app.py"]

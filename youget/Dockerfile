FROM jrottenberg/ffmpeg:ubuntu
RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
RUN apt-get update && apt-get install -y python3-pip
RUN pip3 install you-get
ENTRYPOINT ["you-get"]
ENV LC_CTYPE C.UTF-8

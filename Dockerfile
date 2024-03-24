FROM debian:12.5

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app


RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update && \
    apt-get install -y curl unzip zip g++ wget && \
    apt-get install -y openjdk-17-jdk openjdk-17-jre



COPY docker_dependencies/BBMap_39.06.tar.gz .
RUN tar -xvzf BBMap_39.06.tar.gz && \
    rm BBMap_39.06.tar.gz 

ENV bbmap_reformat="/usr/src/app/bbmap/reformat.sh"

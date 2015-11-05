FROM ubuntu-upstart:14.04

RUN apt-get update
RUN apt-get install -y nginx git
RUN apt-get install -y nodejs-legacy npm
RUN apt-get install -y ruby-dev

COPY files/prepare_image.sh /home/root/prepare_image.sh
RUN /bin/bash /home/root/prepare_image.sh

RUN apt-get clean

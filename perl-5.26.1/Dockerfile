FROM ubuntu:16.04

MAINTAINER Paul Johnson <paul@pjcj.net>

ENV TERM=xterm

RUN apt-get update && apt-get -y install wget build-essential

WORKDIR /usr/local/src
RUN wget http://www.cpan.org/src/5.0/perl-5.26.1.tar.gz -O - | tar xzf -
RUN cd perl-5.26.1 && ./Configure -des && make install

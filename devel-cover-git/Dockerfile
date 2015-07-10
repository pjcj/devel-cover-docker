FROM pjcj/devel-cover-base:latest

MAINTAINER Paul Johnson <paul@pjcj.net>

WORKDIR /usr/local/src
RUN git clone https://github.com/pjcj/Devel--Cover.git
WORKDIR /usr/local/src/Devel--Cover
RUN git checkout master
RUN perl -v
RUN perl Makefile.PL && make t
# RUN make install
ENV CPANCOVER_LOCAL 1
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:./utils

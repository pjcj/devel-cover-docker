#!/bin/sh

docker build --no-cache -t pjcj/perl-5.24.1      perl-5.24.1      && \
docker build --no-cache -t pjcj/devel-cover-base devel-cover-base && \
docker build --no-cache -t pjcj/devel-cover-git  devel-cover-git  && \
docker build            -t pjcj/cpancover        cpancover        && \
docker push pjcj/cpancover                                        && \
echo done

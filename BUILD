#!/bin/sh

docker build            -t pjcj/perl-5.22.0      perl-5.22.0      && \
docker build            -t pjcj/devel-cover-base devel-cover-base && \
docker build --no-cache -t pjcj/devel-cover-git  devel-cover-git  && \
docker build            -t pjcj/cpancover        cpancover        && \
docker push pjcj/cpancover                                        && \
echo done

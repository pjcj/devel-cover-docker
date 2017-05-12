Devel::Cover Docker
===================

This repository contains Dockerfiles and a script to create the docker images
for [cpancover] (http://cpancover.com).

To build the latest image, run ./BUILD

This command will build a docker image for running a Devel::Cover run on a
module, and this will be used in cpancover.com.

On the ccpancover server, check out the version of Devel::Cover you want to use
and then run:

  $ dc cpancover-run

This will simply run forever in the foreground or, at least, until something
breaks.

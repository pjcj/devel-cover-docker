Devel::Cover Docker
===================

This repository contains Dockerfiles and a script to create the docker images
for [cpancover](http://cpancover.com).

To build the latest image, run `./BUILD`

If you don't have permissions to push the image as user `pjcj` then edit
`BUILD` to point to a user for whom you do have permissions.

This command will build a docker image for running a Devel::Cover run on a
module, and this will be used in cpancover.com.

On the cpancover server, check out the version of Devel::Cover you want to use
and then follow the instructions in
[docs/cpancover.md](https://github.com/pjcj/Devel--Cover/blob/master/docs/cpancover.md).

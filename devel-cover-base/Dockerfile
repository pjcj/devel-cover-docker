FROM pjcj/perl-5.22.0:latest

MAINTAINER Paul Johnson <paul@pjcj.net>

WORKDIR /usr/local/src
RUN apt-get -y install git libssl-dev

RUN cpan -iTf App::cpanminus
RUN cpanm -n Sereal Digest::MD5 Template Pod::Coverage::CountParents \
             Capture::Tiny Parallel::Iterator Template Class::XSAccessor \
             Moo namespace::clean CPAN::Releases::Latest CGI
RUN rm -rf ~/.cpan/build ~/.cpan/sources/authors ~/.cpanm \
           ~/.local/share/.cpan/build ~/.local/share/.cpan/sources/authors

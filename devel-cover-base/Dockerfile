# hadolint ignore=DL3007
FROM pjcj/perl-5.38.2:latest

WORKDIR /usr/local/src
# hadolint ignore=DL3008
RUN apt-get update && \
  apt-get -y --no-install-recommends install git libssl-dev libz-dev && \
  rm -rf /var/lib/apt/lists/*

RUN                                                                        \
  cpan -iTf App::cpanminus &&                                              \
  cpanm -n Sereal Digest::MD5 Template Pod::Coverage::CountParents         \
             Capture::Tiny Parallel::Iterator Template Class::XSAccessor   \
             Moo namespace::clean CPAN::Releases::Latest CGI JSON::MaybeXS \
             CPAN::DistnameInfo B::Debug &&                                \
  rm -rf ~/.cpan/build ~/.cpan/sources/authors ~/.cpanm                    \
           ~/.local/share/.cpan/build ~/.local/share/.cpan/sources/authors

# hadolint ignore=DL3007
FROM pjcj/perl-5.38.2:latest

WORKDIR /usr/local/src
# hadolint ignore=DL3008
RUN                                                                          \
  apt-get update &&                                                          \
  apt-get -y --no-install-recommends install git libssl-dev libz-dev         \
    ca-certificates &&                                                       \
  update-ca-certificates &&                                                  \
  rm -rf /var/lib/apt/lists/*

RUN                                                                          \
  cpan -Ti \
    B::Debug \
    CGI \
    CPAN::DistnameInfo \
    CPAN::Releases::Latest \
    Capture::Tiny \
    Class::XSAccessor \
    Digest::MD5 \
    JSON::MaybeXS \
    Moo \
    Parallel::Iterator \
    Pod::Coverage::CountParents \
    Sereal \
    Template \
    Template \
    namespace::clean \
  && rm -rf ~/.cpan/build ~/.cpan/sources/authors ~/.cpanm                      \
    ~/.local/share/.cpan/build ~/.local/share/.cpan/sources/authors

#!/usr/bin/env bash

set -eEuo pipefail
shopt -s inherit_errexit

script=$(basename "$0")
scrdir=$(readlink -f "$(dirname "$0")")
readonly LOG_FILE="/tmp/$script.log"
_p() {
  l=$1
  shift
  echo "$l: $script $*" | tee -a "$LOG_FILE" >&2
}
pt() { _p "[TRACE]  " "$*"; }
pd() { _p "[DEBUG]  " "$*"; }
pi() { _p "[INFO]   " "$*"; }
pw() { _p "[WARNING]" "$*"; }
pe() { _p "[ERROR]  " "$*"; }
pf() {
  _p "[FATAL]  " "$*"
  exit 1
}

usage() {
  cat <<EOT
$script --help
$script --trace --verbose
$script --user=pjcj --image=cpancover --no-cache
$script --env=[prod|dev]
EOT
  exit 0
}

cleanup() {
  declare -r res=$?
  ((verbose)) && pi "Cleaning up"
  exit $res
}

PATH="$scrdir:$PATH"
verbose=0
user=pjcj
perl="5.38.2"
image=cpancover
nocache=""

while [[ $# -gt 0 ]]; do
  case "$1" in
  -h | --help)
    usage
    ;;
  -t | --trace)
    set -x
    shift
    ;;
  -v | --verbose)
    verbose=1
    shift
    ;;
  -u | --user)
    user="$2"
    shift 2
    ;;
  -i | --image)
    image="$2"
    shift 2
    ;;
  -p | --perl)
    perl="$2"
    shift 2
    ;;
  -n | --no-cache)
    nocache="--no-cache"
    shift
    ;;
  -e | --env)
    shift
    case "$1" in
    prod)
      user=pjcj
      image=cpancover
      shift
      ;;
    dev)
      user=pjcj
      image=cpancover_dev
      shift
      ;;
    *)
      pf "Unrecognised environment: $1"
      ;;
    esac
    ;;
  *)
    break
    ;;
  esac
done

build_perl() {
  local p="perl-$perl"
  pi "Building docker for $p"
  local f="$p.tmp"
  cat <<EOF >"$f"
FROM ubuntu:24.04

ENV TERM=xterm
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008
RUN apt-get update && apt-get -y --no-install-recommends \
  install wget build-essential \
  && rm -rf /var/lib/apt/lists/*

RUN wget --progress=dot:giga http://www.cpan.org/src/5.0/$p.tar.gz \
  -O - | tar xzvf - -C /usr/local/src
WORKDIR /usr/local/src/$p
RUN ./Configure -des && make install
WORKDIR /
RUN rm -rf /usr/local/src/$p
EOF

  mkdir -p "$p"
  local df="$p/Dockerfile"
  if diff -q "$f" "$df"; then
    rm "$f"
  else
    pi "Writing dockerfile $df"
    mv "$f" "$df"
  fi

  local cdf=devel-cover-base/Dockerfile
  local l1="FROM pjcj/$p:latest"
  if [[ $(head -2 $cdf | tail -1) != "$l1" ]]; then
    pi "Updating FROM line in $cdf to $p"
    perl -pi -e "\$_ = qq($l1\\n) if \$. == 2" $cdf
  fi
}

build() {
  pi "Building $user/$image"
  docker build $nocache -t "$user/perl-$perl" "perl-$perl" &&
    docker build $nocache -t "$user/devel-cover-base" devel-cover-base &&
    docker build --no-cache -t "$user/devel-cover-git" devel-cover-git &&
    docker build -t "$user/$image" cpancover &&
    docker push "$user/$image" &&
    pi "done"
}

main() {
  ((verbose)) && pi "Running $*"
  case "${1-build}" in
  build)
    build_perl
    build
    ;;
  devel-cover-base-shell)
    docker run -it \
      --rm=false \
      "$user/devel-cover-base" /bin/bash
    ;;
  options)
    perl -nE 'say $1 =~ s/"//gr =~ s/\s*\|\s*/\n/gr' \
      -E 'if /^ {2}"?([a-zA-Z0-9_ "|\\-]+)"?(?:\)|\s*\|\s*\\)$/' \
      -E '&& $1 !~ /^_/' <"$0"
    ;;
  *)
    pf "Unknown option: $1"
    ;;
  esac
}

if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
  trap cleanup EXIT INT
  main "$@"
fi

# vim: ft=bash

#!/bin/bash

set -euo pipefail
# IFS=$'\n\t'

script=$(basename "$0")
scrdir=$(readlink -f "$(dirname "$0")")
readonly LOG_FILE="/tmp/$script.log"
_p() { l=$1; shift; echo "$l: $script $*" | tee -a "$LOG_FILE" >&2; }
pt() { _p "[TRACE]  " "$*";                                         }
pd() { _p "[DEBUG]  " "$*";                                         }
pi() { _p "[INFO]   " "$*";                                         }
pw() { _p "[WARNING]" "$*";                                         }
pe() { _p "[ERROR]  " "$*";                                         }
pf() { _p "[FATAL]  " "$*"; exit 1;                                 }

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
perl="5.28.0"
image=cpancover
nocache=""

while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)
            usage
            ;;
        -t|--trace)
            set -x
            shift
            ;;
        -v|--verbose)
            verbose=1
            shift
            ;;
        -u|--user)
            user="$2"
            shift 2
            ;;
        -i|--image)
            image="$2"
            shift 2
            ;;
        -p|--perl)
            perl="$2"
            shift 2
            ;;
        -n|--no-cache)
            nocache="--no-cache"
            shift
            ;;
        -e|--env)
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
    p="perl-$perl"
    pi "Building docker for $p"
    f="$p.tmp"
    cat <<EOF > "$f"
FROM ubuntu:18.04

MAINTAINER Paul Johnson <paul@pjcj.net>

ENV TERM=xterm

RUN apt-get update && apt-get -y install wget build-essential

WORKDIR /usr/local/src
RUN wget http://www.cpan.org/src/5.0/$p.tar.gz -O - | tar xzf -
RUN cd $p && ./Configure -des && make install
EOF

    mkdir -p "$p"
    df="$p/Dockerfile"
    if diff -q "$f" "$df"; then
        rm "$f"
    else
        pi "Writing dockerfile $df"
        mv "$f" "$df"
    fi

    cdf=devel-cover-base/Dockerfile
    l1="FROM pjcj/$p:latest"
    if [[ $(head -1 $cdf) != "$l1" ]]; then
        pi "Updating FROM line in $cdf to $p"
        perl -pi -e "\$_ = qq($l1\\n) if \$. == 1" $cdf
    fi
}

build() {
    pi "Building $user/$image"
    docker build $nocache   -t "$user/perl-$perl"       "perl-$perl"      && \
    docker build $nocache   -t "$user/devel-cover-base" devel-cover-base  && \
    docker build --no-cache -t "$user/devel-cover-git"  devel-cover-git   && \
    docker build            -t "$user/$image"           cpancover         && \
    docker push "$user/$image"                                            && \
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
            docker run -it                            \
                --rm=false                            \
                "$user/devel-cover-base" /bin/bash
            ;;
        options)
            perl -nE 'say $1 =~ s/"//gr =~ s/\s*\|\s*/\n/gr'               \
                -E 'if /^ {8}"?([a-zA-Z0-9_ "|\\-]+)"?(?:\)|\s*\|\s*\\)$/' \
                -E '&& $1 !~ /^_/' < "$0"
            ;;
        *)
            pf "Unknown option: $1"
            ;;
    esac
}

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
    trap cleanup EXIT INT
    main "$@"
fi

# vim: ft=sh

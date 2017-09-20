#!/bin/bash

set -euo pipefail
# set -x
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
image=cpancover
nocache=""

while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)
            usage
            shift
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
                    break
                    ;;
            esac
            ;;
        *)
            break
            ;;
    esac
done

build() {
    pi "Building $user/$image"
    docker build $nocache   -t "$user/perl-5.26.0"      perl-5.26.0       && \
    docker build $nocache   -t "$user/devel-cover-base" devel-cover-base  && \
    docker build --no-cache -t "$user/devel-cover-git"  devel-cover-git   && \
    docker build            -t "$user/$image"           cpancover         && \
    docker push "$user/$image"                                            && \
    echo "done"
}

main() {
    ((verbose)) && pi "Running $*"
    case "${1-build}" in
        build)
            build
            ;;
        options)
            perl -nE 'say $1 =~ s/"//gr =~ s/\s*\|\s*/\n/gr' \
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

# For zsh completion:
# _%FILE%() { reply=($(%FILE% options)) }
# compctl -K _%FILE% %FILE%

# vim: ft=sh

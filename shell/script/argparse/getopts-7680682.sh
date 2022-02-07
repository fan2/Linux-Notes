#!/usr/bin/env bash

# https://stackoverflow.com/questions/402377/using-getopts-to-process-long-and-short-command-line-options
# Arvid Requate - https://stackoverflow.com/a/7680682

optspec=":hv-:"
while getopts "$optspec" opt; do
    case "${opt}" in
    -)
        echo "opt=$opt, OPTARG=$OPTARG, OPTIND=$OPTIND" # debug
        case "${OPTARG}" in
        loglevel)
            val="${!OPTIND}"
            OPTIND=$(($OPTIND + 1))
            echo "Parsing option: '--${OPTARG}', value: '${val}'" >&2
            ;;
        loglevel=*)
            val=${OPTARG#*=}    # 截=左留右
            opt=${OPTARG%=$val} # 截=右留左
            echo "Parsing option: '--${opt}', value: '${val}'" >&2
            ;;
        *)
            if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
                echo "Unknown option --${OPTARG}" >&2
            fi
            ;;
        esac
        ;;
    h)
        echo "usage: $0 [-v] [--loglevel[=]<value>]" >&2
        exit 2
        ;;
    v)
        echo "Found option '-${opt}'" >&2
        ;;
    *)
        if [ "$OPTERR" != 1 ] || [ "${optspec:0:1}" = ":" ]; then
            echo "Non-option argument: '-${OPTARG}'" >&2
        fi
        ;;
    esac
done

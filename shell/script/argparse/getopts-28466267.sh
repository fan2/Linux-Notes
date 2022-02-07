#!/usr/bin/env bash

# https://stackoverflow.com/questions/402377/using-getopts-to-process-long-and-short-command-line-options
# Adam Katz - https://stackoverflow.com/a/28466267

# complain to STDERR and exit with error
die() {
    echo "$*" >&2
    exit 2
}

# 判断输入的长选项名称是否需要带参数
need_arg() {
    # if ! [ $# -eq 0 ]
    if [ $# -gt 0 ]; then
        case $1 in
        bravo | charlie | electric )
            return 0
            ;;
        *)
            # echo "Unkown option: $1" >&2
            return 1
            ;;
        esac
    else
        return 1
    fi
}

# 判断环境变量 OPTARG 是否有值，为空则退出
check_arg() {
    if [ -z "$OPTARG" ]; then
        die "No arg for --$OPT option"
    fi
}

while getopts ab:c:d:e:-: OPT; do
    optKind="short"
    # long option: reformulate OPT and OPTARG
    if [ "$OPT" = "-" ]; then
        optKind="long"
        if [[ $OPTARG == *=* ]]; then
            # 无论是否带参数都不影响
            echo ">>> long option: '--${OPTARG}'" >&2
            OPT="${OPTARG%%=*}"     # extract long option name on left of `=`
            OPTARG="${OPTARG#$OPT}" # extract long option argument (may be empty) on right of OPT
            OPTARG="${OPTARG#=}"    # if long option argument, remove assigning `=`
        else
            OPT=$OPTARG
            # 检测长选项是否要带参数
            need_arg $OPT
            if [ $? -eq 0 ]; then
                # 将后一个选项，当做该选项的参数
                OPTARG="${!OPTIND}"
                echo ">>> long option: '--${OPT} ${OPTARG}'" >&2
                OPTIND=$(($OPTIND + 1))
            else
                echo ">>> long option: '--${OPT}'" >&2
            fi
        fi
    fi
    case "$OPT" in
    a | alpha)
        echo "Found $optKind option '${OPT}'" >&2
        alpha=true
        ;;
    b | bravo)
        check_arg
        echo "Parsing $optKind option: '${OPT}', value: '${OPTARG}'" >&2
        bravo="$OPTARG"
        ;;
    c | charlie)
        check_arg
        echo "Parsing $optKind option: '${OPT}', value: '${OPTARG}'" >&2
        charlie="$OPTARG"
        ;;
    d | dogtail)
        echo "Found $optKind option '${OPT}'" >&2
        dogtail=true
        ;;
    e | electric)
        check_arg
        echo "Parsing $optKind option: '${OPT}', value: '${OPTARG}'" >&2
        electric="$OPTARG"
        ;;
    ??*) die "Illegal $optKind option --$OPT" ;; # bad long option
    ?) exit 2 ;;                                 # bad short option (error reported via getopts)
    esac
done

# remove parsed options and args from $@ list
shift $((OPTIND - 1))

# continue to parse common params

echo "last params: $*"

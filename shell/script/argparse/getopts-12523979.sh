#!/bin/bash

# https://stackoverflow.com/questions/402377/using-getopts-to-process-long-and-short-command-line-options
# RapaNui - https://stackoverflow.com/a/12523979

# foobar: getopts with short and long options AND arguments

function _cleanup() {
    unset -f _usage _cleanup
    return 0
}

## Clear out nested functions on exit
trap _cleanup INT EXIT RETURN

###### some declarations for this example ######
Options=$@
Optnum=$#
sfoo='no '
sbar='no '
sfoobar='no '
sbarfoo='no '
sarguments='no '
sARG=empty
lfoo='no '
lbar='no '
lfoobar='no '
lbarfoo='no '
larguments='no '
lARG=empty

function _usage() {
    ###### U S A G E : Help and ERROR ######
    cat <<EOF
    foobar $Options
    $*
        usage: foobar <[options]>
        Options:
            -b --bar            Set bar to yes (\$bar)
            -f --foo            Set foo to yes (\$foo)
            -h --help           Show this message
            -A --arguments=...  Set arguments to yes (\$arguments) AND get ARGUMENT (\$ARG)
            -B --barfoo         Set barfoo to yes (\$barfoo)
            -F --foobar         Set foobar to yes (\$foobar)
EOF
}

[ $# = 0 ] && _usage "  >>>>>>>> no options given "

##################################################################
#######  "getopts" with: short options  AND  long options  #######
#######            AND  short/long arguments               #######
while getopts ':bfh-A:BF' OPTION; do
    case "$OPTION" in
    b)
        echo "Found option '-${OPTION}'" >&2
        sbar=yes
        ;;
    f)
        echo "Found option '-${OPTION}'" >&2
        sfoo=yes
        ;;
    h) _usage ;;
    A)
        echo "Parsing option: '-${OPTION}', value: '${OPTARG}'" >&2
        sarguments=yes
        sARG="$OPTARG"
        ;;
    B)
        echo "Found option '-${OPTION}'" >&2
        sbarfoo=yes
        ;;
    F)
        echo "Found option '-${OPTION}'" >&2
        sfoobar=yes
        ;;
    -)
        [ $OPTIND -ge 1 ] && optind=$(expr $OPTIND - 1) || optind=$OPTIND
        eval OPTION="\$$optind"
        OPTARG=$(echo $OPTION | cut -d'=' -f2)
        OPTION=$(echo $OPTION | cut -d'=' -f1)
        case $OPTION in
        --foo)
            echo "Found option '${OPTION}'" >&2
            lfoo=yes
            ;;
        --bar)
            echo "Found option '${OPTION}'" >&2
            lbar=yes
            ;;
        --foobar)
            echo "Found option '${OPTION}'" >&2
            lfoobar=yes
            ;;
        --barfoo)
            echo "Found option '${OPTION}'" >&2
            lbarfoo=yes
            ;;
        --help) _usage ;;
        --arguments)
            echo "Parsing option: '${OPTION}', value: '${OPTARG}'" >&2
            larguments=yes
            lARG="$OPTARG"
            ;;
        # *) _usage " Long: >>>>>>>> invalid options (long) " ;;
        *) echo ">>>>>>>> invalid long options : $OPTION" ;;
        esac
        OPTIND=1
        shift
        ;;
    # ?) _usage "Short: >>>>>>>> invalid options (short) " ;;
    ?) echo ">>>>>>>> invalid short options : $OPTION" ;;
    esac
done

#!/bin/bash

# https://stackoverflow.com/a/8597411
function get_ostype_1 {
    local platform1='unknown'
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        platform1='linux'
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        platform1='macos'
    elif [[ "$OSTYPE" == "msys" ]]; then
        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
        platform1='win(msys)'
    elif [[ "$OSTYPE" == "cygwin" ]]; then
        # POSIX compatibility layer and Linux environment emulation for Windows
        platform1='win(cygwin)'
    elif [[ "$OSTYPE" == "win32" ]]; then
        # I'm not sure this can happen.
        platform1='win32'
    elif [[ "$OSTYPE" == "freebsd"* ]]; then
        platform1='freebsd'
    fi
    echo "$platform1"
}

# https://stackoverflow.com/a/18434831
function get_ostype_2 {
    local platform2='unknown'
    case "$OSTYPE" in
    linux*)
        platform2='linux'
        ;;
    darwin*)
        platform2='macos'
        ;;
    bsd*)
        platform2='bsd'
        ;;
    solaris*)
        platform2='solaris'
        ;;
    msys*)
        platform2='win(msys)'
        ;;
    cygwin*)
        platform2='win(cygwin)'
        ;;
    *) ;;
    esac
    echo "$platform2"
}

# Detect the platform (similar to $OSTYPE)
get_ostype_3() {
    local OS="$(uname)"
    local platform3='unknown'
    case $OS in
    'Linux')
        platform3='linux'
        ;;
    'Darwin')
        platform3='macos'
        ;;
    'FreeBSD')
        platform3='freebsd'
        ;;
    'SunOS')
        platform3='solaris'
        ;;
    'WindowsNT')
        platform3='windows'
        ;;
    'AIX')
        OS='aix'
        ;;
    *) ;;
    esac
    echo "$platform3"
}

# https://stackoverflow.com/a/29239609
if_os() {
    [[ $OSTYPE == *$1* ]]
}

if_nix() {
    case "$OSTYPE" in
    *linux* | *hurd* | *msys* | *cygwin* | *sua* | *interix*) sys="gnu" ;;
    *bsd* | *darwin*) sys="bsd" ;;
    *sunos* | *solaris* | *indiana* | *illumos* | *smartos*) sys="sun" ;;
    esac
    [[ "${sys}" == "$1" ]]
}

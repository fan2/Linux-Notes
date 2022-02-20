#!/bin/bash

# Read either the first argument or from stdin

# test cases
## 1. `./read_by_line.sh README.md`：打印文件。  
## 2. `./read_by_line.sh`：等待键盘输入，然后回显。  
## 3. `./read_by_line.sh << eof`：等待键盘输入内容，输入eof结束，然后回显。  
## 4. `./read_by_line.sh <<< hello`：打印回显。  

func7126967() {
    # https://stackoverflow.com/a/7126967
    cat "${1:-/dev/stdin}" >"${2:-/dev/stdout}"
}

func7045517() {
    # https://stackoverflow.com/a/7045517
    while read -r line; do
        echo "$line"
    done <"${1:-/dev/stdin}"
}

func28786207() {
    # https://stackoverflow.com/a/28786207
    file=${1--} # POSIX-compliant; ${1:--}
    while IFS= read -r line; do
        printf '%s\n' "$line" # Or: env POSIXLY_CORRECT=1 echo "$line"
    done < <(cat -- "$file")
}

func28788047() {
    # https://stackoverflow.com/a/28788047
    (($#)) || set -- -
    while (($#)); do
        { [[ $1 = - ]] || exec <"$1"; } &&
            while read -r; do
                printf '%s\n' "$REPLY"
            done
        shift
    done
}

func7126967 "$@"
# func7045517 "$@"
# func28786207 "$@"
# func28788047 "$@"

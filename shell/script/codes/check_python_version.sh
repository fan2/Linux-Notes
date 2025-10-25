#!/bin/bash

################################################################################
# 检测本地是否安装了python
################################################################################

# 已安装提示 Python 3.9.6，输出到 1-stdout
# 未安装提示 zsh: command not found: python，输出到 2-stderr
check_python_version_1()
{
    if python -V &>/dev/null; # 不输出执行结果
    then
        python_version=$(python -V) 1>/dev/null # 不输出版本信息
        echo "python installed: $python_version"
        return 0
    else
        echo "python uninstalled!"
        return 1
    fi
}

# `python -V` 默认将版本信息输出到标准错误（stderr）。
# 因此，使用 `python_version=$(python -V 2>&1)` 将标准错误重定向到标准输出，以便变量能够正确捕获版本信息。
# 外层 `1>/dev/null` 则确保变量赋值命令本身不产生无关输出。
check_python_version_2()
{
    python -V &>/dev/null && {
        python_version=$(python -V 2>&1) 1>/dev/null
        echo "python installed: $python_version"
        return 0
    } || {
        echo "python uninstalled!"
        return 1
    }
}

main()
{
    check_python_version_2
}

################################################################################
# main entry
################################################################################
# echo "param count = $#"
# echo "params = $@"

main "$@" # $*

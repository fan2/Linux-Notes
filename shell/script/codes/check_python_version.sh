#!/bin/bash

################################################################################
# 检测本地是否安装了python
################################################################################

# 已安装提示 Python 3.9.6，输出到 1-stdout
# 未安装提示 zsh: command not found: python，输出到 2-stderr
check_python_version()
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

main()
{
    check_python_version
}

################################################################################
# main entry
################################################################################
# echo "param count = $#"
# echo "params = $@"

main "$@" # $*

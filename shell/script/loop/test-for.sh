#!/bin/bash

test_for_1()
{
    echo "----------------------------------------"
    echo "test_for_1"
    echo "----------------------------------------"
    for loop in 1 2 3 4 5
    do
        echo $loop
    done
}

# testing the C-style for loop
test_for_2()
{
    echo "----------------------------------------"
    echo "test_for_2"
    echo "----------------------------------------"
    for (( i=1; i <= 10; i++ ))
    do
        echo "The next number is $i"
    done
}

test_for_3()
{
    echo "----------------------------------------"
    echo "test_for_3"
    echo "----------------------------------------"
    read -p "PLS input directory to list: " directory
    if [ -d $directory ]
    cd $directory # 如果不进入该目录，以下 -f 测试需要拼接绝对路径
    then
        for filename in `ls -1 $directory`
        do
            if [ -f $filename ]
            then
                echo $filename
            fi
        done
    fi
}

# 使用 for 循环 ping 服务器列表
test_for_4()
{
    echo "----------------------------------------"
    echo "test_for_4"
    echo "----------------------------------------"
    HOSTS="www.qq.com www.tencent.com www.sogo.com"
    for host in $HOSTS
    do
        ping -c 2 $host
    done
}

test_for()
{
    # test_for_0
    test_for_1
    test_for_2
    test_for_3
    test_for_4
}

echo "----------------------------------------"
echo "test_for_0"
echo "----------------------------------------"
for arg
do
    echo "You supplied $arg as a command line option"
done

test_for

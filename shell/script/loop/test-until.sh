#!/bin/bash

test_until_1()
{
    echo "----------------------------------------"
    echo "test_until_1"
    echo "----------------------------------------"
    var1=100
    until [ $var1 -eq 0 ]
    do
        echo $var1
        var1=$[ $var1 - 25 ]
    done
}

# 用while循环逐行读取文本内容
test_until_2()
{
    echo "----------------------------------------"
    echo "test_until_2"
    echo "----------------------------------------"
    var1=100
    until echo $var1
          [ $var1 -eq 0 ]
    do
        echo Inside the loop: $var1
        var1=$[ $var1 - 25 ]
    done
}

test_until()
{
    test_until_1
    test_until_2
}

echo "----------------------------------------"
echo "test_until_0"
echo "----------------------------------------"

var0=0
until [ $var0 -eq 0 ]
do
    echo $var0
done

test_until

#!/bin/bash

test_while_1()
{
    echo "----------------------------------------"
    echo "test_while_1"
    echo "----------------------------------------"
    COUNTER=0
    while [ $COUNTER -lt 5 ]
    do
        COUNTER=`expr $COUNTER + 1` # $[ $COUNTER + 1 ]
        echo $COUNTER
    done
}

# 用while循环逐行读取文本内容
test_while_2()
{
    echo "----------------------------------------"
    echo "test_while_2"
    echo "----------------------------------------"
    # read -p "enter filename:" FILE
    echo -n "PLS enter filename to readline: "
    read FILE
    if [ -f $FILE ]
    then
        while read LINE
        do
            echo $LINE
        done < $FILE
    fi
}

# 用while循环读取键盘输入
test_while_3()
{
    echo "----------------------------------------"
    echo "test_while_3"
    echo "----------------------------------------"
    echo "type <CTRL-D> to terminate"
    echo "enter your most liked films: "
    index=0
    while read FILM
    do
        # index+=1 # string contact!!!
        # index=`expr $index + 1`
        index=$[ $index + 1 ]
        echo "Yeah, great film[$index]: $FILM"
    done
}

test_while()
{
    test_while_1
    test_while_2
    test_while_3
}

test_while
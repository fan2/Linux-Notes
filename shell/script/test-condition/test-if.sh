#!/bin/bash

test_if_1()
{
    echo "----------------------------------------"
    echo "test_if_1"
    echo "----------------------------------------"
    # read -p "PLS input the num (1-10): " ANS
    echo -n "PLS input the num (1-10): "
    read num

    while [[ $num != 4 ]]
    do
        if [ $num -lt 4 ]
        then
            echo "Too small. Try again!"
            read num
        elif [ $num -gt 4 ]
        then
            echo "Too high. Try again!"
            read num
        else
            # echo "Congratulation, you are right!" # no output !?
            exit 0
        fi
    done

    echo "Congratulation, you are right!"
}

test_if_2()
{
    echo "----------------------------------------"
    echo "test_if_2"
    echo "----------------------------------------"
}

test_if()
{
    test_if_1
    test_if_2
}

test_if

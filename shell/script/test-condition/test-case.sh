#!/bin/bash

test_case_1()
{
    echo "----------------------------------------"
    echo "test_case_1"
    echo "----------------------------------------"
    # read -p "enter a number from 1 to 5:" ANS
    echo -n "enter a number from 1 to 5: "
    read ANS
    case $ANS in
        1) echo "you select 1"
            ;;
        2) echo "you select 2"
            ;;
        3) echo "you select 3"
            ;;
        4) echo "you select 4"
            ;;
        5) echo "you select 5"
            ;;
        *) echo "`basename $0`: This is not between 1 and 5" >&2
            exit 1
            ;;
    esac
}

test_case_2()
{
    echo "----------------------------------------"
    echo "test_case_2"
    echo "----------------------------------------"
    read -p "Do you wish to proceed [y..n] : " ANS
    case $ANS in
        y|Y|yes|Yes) echo "yes is selected"
            ;;
        n|N) echo "no is selected"
            exit 0 # no error so only use exit 0 to terminate
            ;;
        *) echo "`basename $0`: Unknown response" >&2
            exit 1
            ;;
    esac
    # if we are here then a y|Y|yes|Yes was selected only
}

test_case()
{
    test_case_1
    test_case_2
}

test_case

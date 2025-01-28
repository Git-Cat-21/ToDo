#!/bin/bash

if [[ "$1" == "-a" ]]; then 
    echo "to add tasks"
    if [[ -f "todo.txt" ]]; then
        lastline= tail -n 1 todo.txt
        echo $lastline
        printf "this is the first task when file exists\n" >> todo.txt
    else
        printf "this is the first task when file doesnt exist\n" >> todo.txt
    fi
    
elif [[ "$1" == "-d" ]]; then
    echo "to delete tasks"

elif [[ "$1" == "-l" ]]; then 
    # echo "to list tasks"
    cat todo.txt

else
    echo "invalid argument"
fi


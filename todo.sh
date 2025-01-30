#!/bin/bash

if [[ "$1" == "-a" ]]; then 
    echo "to add tasks"
    if [[ -f "todo.txt" ]]; then
        echo "file exists"

        if [[ -z "$2" ]]; then
            read -p "No task entered... enter the task   " task
            echo "$task" >> todo.txt
        else 
            printf "$2\n" >> todo.txt
        fi
    fi
    
elif [[ "$1" == "-d" ]]; then
    echo "to delete tasks"

elif [[ "$1" == "-l" ]]; then 
    # echo "to list tasks"
    cat todo.txt

else
    echo "invalid argument"
fi


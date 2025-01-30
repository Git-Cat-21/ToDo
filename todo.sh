#!/bin/bash

if [[ "$1" == "-a" ]]; then 
    if [[ -f "todo.txt" ]]; then
        line_no=$(cat todo.txt | wc -l)

        if [[ -z "$2" ]]; then
            read -p "No task entered... enter the task:  " task
            echo "$((line_no))\t$task" >> todo.txt
        else 
            echo "$((line_no))\t$2\n" >> todo.txt
        fi
        
    else 
        line_no = 1
        if [[ -z "$2" ]]; then
                read -p "No task entered... enter the task   " task
                echo "$((line_no))\t$task" >> todo.txt
            else 
                echo "$((line_no))\t$2\n" >> todo.txt
            fi
    fi
    
elif [[ "$1" == "-d" ]]; then
    echo "to delete tasks"

elif [[ "$1" == "-l" ]]; then 
    cat todo.txt

else
    echo "invalid argument"
fi


#!/bin/bash

if [[ "$1" == "-a" ]]; then 
    if [[ -f "todo.txt" ]]; then
        line_no=$(cat todo.txt | wc -l)

        if [[ -z "$2" ]]; then
            read -p "No task entered... enter the task:  " task
            printf "$((line_no+1))\t$task" >> todo.txt
        else 
            printf "$((line_no+1))\t$2\n" >> todo.txt
        fi

    else 
        line_no=1
        if [[ -z "$2" ]]; then
                read -p "No task entered... enter the task   " task
                printf "$line_no\t$task" >> todo.txt
            else 
                printf "$line_no\t$2\n" >> todo.txt
            fi
    fi
    
elif [[ "$1" == "-d" ]]; then

    if [[ -z "$2" ]]; then
        read -p "Enter the task number...:   " task_no
    else
        task_no="$2"
    fi

    task=$(awk -v task_no="$task_no" -F'\t' '$1 == task_no {print $2}' todo.txt)

    if  [[ -n "$task" ]]; then
        echo "This is your task: $task"
        echo "Task exists. Here we mark it as done."

        sed -i "${task_no}s/$/ (done)/" todo.txt
    else
        echo "Task doesnt exist. So, nahhh"
    fi

elif [[ "$1" == "-l" ]]; then 
    cat todo.txt

else
    echo "invalid argument"
fi


#!/bin/bash

file="todo.txt"
RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

usage(){
    echo "A simple command-line tool to  manage to-do list"
    echo 
    echo -e "${GREEN}Usage:${ENDCOLOR} ./todo.sh [OPTION] [<ARGUMENT>]"
    echo "-a <task>             To add a task to the list"
    echo "-d <task_number>      Mark task as done"      
    echo "-l                    List all tasks"
    echo "-h                    Help function"
}

if [[ "$1" == "-a" ]]; then 
    
    if [[ -f "$file" ]]; then    
        line_no=$(wc -l < "$file")
    else
        line_no=0
    fi 

    if [[ -z "$2" ]]; then
        read -p "No task entered... enter the task: " task
    else
        task="$2"
    fi

    printf "%d\t%s\n" "$((line_no + 1))" "$task" >> "$file"
    
elif [[ "$1" == "-d" ]]; then

    if [[ -z "$2" ]]; then
        read -p "Enter the task number...:   " task_no
    else
        task_no="$2"
    fi

    task=$(cat todo.txt | grep $task_no)

    if  [[ -n "$task" ]]; then
        sed -i "${task_no}s/$/ (DONE)/" todo.txt
    else
        echo "Task doesnt exist. Enter a valid number"
    fi

elif [[ "$1" == "-l" ]]; then 
    while read -r LINE
    do 
        if echo "$LINE" | grep -q "(DONE)"; then
            printf "${GREEN}%s${ENDCOLOR}\n" "$LINE"
        else
            printf "${RED}%s${ENDCOLOR}\n" "$LINE"
        fi
    done < "$file"

elif [[ "$1" == "-h" ]]; then
    usage

else
    echo "invalid argument"
fi


#!/bin/bash

if [[ "$1" == "-a" ]]; then 
    echo "to add tasks"
    printf "this is my first task" >> todo.txt
    

elif [[ "$1" == "-d" ]]; then
    echo "to delete tasks"

elif [[ "$1" == "-l" ]]; then 
    echo "to list tasks"

else
    echo "invalid argument"

fi


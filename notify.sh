#!/bin/bash

file="$HOME/todo.txt"
if grep -qv "✅" "$file"; then    
    notify-send "ToDo" "You have pending tasks!"
fi
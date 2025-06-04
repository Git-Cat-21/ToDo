#!/bin/bash

file="$HOME/todo.txt"
hist_file="$HOME/history_todo.txt"
RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

ascii_art="████████╗ ██████╗ ██████╗  ██████╗ 
╚══██╔══╝██╔═══██╗██╔══██╗██╔═══██╗
   ██║   ██║   ██║██║  ██║██║   ██║
   ██║   ██║   ██║██║  ██║██║   ██║
   ██║   ╚██████╔╝██████╔╝╚██████╔╝
   ╚═╝    ╚═════╝ ╚═════╝  ╚═════╝"



usage(){
    echo "---------------------------------------"
    echo "$ascii_art"
    echo "---------------------------------------"
    echo "A simple command-line tool to  manage to-do list"
    echo 
    echo -e "${GREEN}Usage:${ENDCOLOR} todo [OPTION] [<ARGUMENT>]"
    echo
    echo "-a <task>                 Add a new task to the list"
    echo "-d <task_num>             Mark a specific task as done"      
    echo "-l                        List all tasks (both done and pending)"
    echo "-r <task_num>             Remove a specific task from the list"
    echo "-lp                       List only the pending tasks"
    echo "-e <task_num> <new_task>  Edit an existing task"
    echo "-u <task_num>             Undo completion of a task"
    echo "-c                        Clear all tasks from the list" 
    echo "-s <keyword>              Search for tasks containing a keyword" 
    echo "-his                      Show the entire history of tasks (including deleted or edited)"
    echo "-h                        Display this help menu"   
  }

reindex_tasks() {
    tmpfile=$(mktemp)
    lineno=1
    while IFS=$'\t' read -r num task; do
        echo -e "$lineno\t$task" >> "$tmpfile"
        ((lineno++))
    done < "$file"
    mv "$tmpfile" "$file"
}

cleanup_tasks() {
    grep -v "✅" "$file" > "$file.tmp"
    mv "$file.tmp" "$file"
    reindex_tasks
}

if [[ ! -f "$file" || ! -f "$hist_file" ]]; then 
    touch "$file" "$hist_file"
fi 


# Add a task
if [[ "$1" == "-a" ]]; then 
    
    if [[ -f "$file" ]]; then    
        line_no=$(wc -l < "$file")
        line_no_fh=$(wc -l < "$hist_file")
    else
        line_no=0
    fi 

    if [[ -z "$2" ]]; then
        read -p "No task entered... enter the task: " task
    else
        task="$2"
    fi

    printf "%d\t%s\n" "$((line_no + 1))" "$task" >> "$file"
    printf "%d\t%s\t[%s]\n" "$((line_no_fh + 1))" "$task" "$(date)" >> "$hist_file"

    echo "Task entered successfully."
    reindex_tasks

# Mark task as done
elif [[ "$1" == "-d" ]]; then
    read -p "Are you sure you want to mark the task done yes(y) or no(n) " choice
    if [[ "$choice" == "y" || -z "$choice" ]]; then
        if [[ -z "$2" ]]; then
            read -p "Enter the task number...:   " task_no
        else
            task_no="$2"
        fi

        task=$(cat "$file" | grep $task_no)

        if grep -q "^$task_no[[:space:]]" "$file"; then
            sed -i "/^$task_no[[:space:]]/s/$/ ✅/" "$file"
            echo "Task $task_no marked done successfully."
        else
            echo "Task doesn't exist. Enter a valid number."
        fi

    fi

# To list all tasks
elif [[ "$1" == "-l" ]]; then 
    while read -r LINE; do 
        # if echo "$LINE" | grep -q "(DONE)"; then
        if echo "$LINE" | grep -q "✅"; then
            printf "${GREEN}%s${ENDCOLOR}\n" "$LINE"
        else
            printf "${RED}%s${ENDCOLOR}\n" "$LINE"
        fi
    done < "$file"

# Remove a task
elif [[ "$1" == "-r" ]]; then
    read -p "Are you sure you wish to remove a task yes(y) or no(n) " choice
    if [[ "$choice" == "y" || -z "$choice" ]]; then
        if [[ -z "$2" ]]; then
            read -p "Please provide a task number to remove. " task
        else
            task="$2"
        fi

        if grep -q "$task[[:space:]]" "$file"; then
            # sed -i "/${task}/d" "$file"
            sed -i "/^$task[[:space:]]/d" "$file"
            echo "Task $task removed."
            reindex_tasks
        else
            echo "Task number doesn't exist!!!"
        fi
    fi

# Show pending tasks only
elif [[ "$1" == "-lp" ]]; then 
    while read -r LINE; do 
        # if echo "$LINE" | grep -q "(DONE)"; then
        if echo "$LINE" | grep -q "✅"; then
            continue
        else
            printf "${RED}%s${ENDCOLOR}\n" "$LINE"
        fi
    done < "$file"

# To edit tasks
elif [[ "$1" == "-e" ]]; then
    read -p "Are you sure you wish to edit the task yes(y) or no(n) " choice
    if [[ "$choice" == "y" || -z "$choice" ]]; then
        if [[ -z "$2" ]]; then
            read -p "Enter the task number...:   " task_no
        else
            task_no="$2"
        fi

        if ! grep -q "^$task_no[[:space:]]" "$file"; then
            echo "Task doesn't exist. Enter a valid number."
            exit 1
        fi

        if [[ -z "$3" ]]; then
            read -p "Enter the new task description: " new_task
        else
            new_task="$3"
        fi

        sed -i "s/^$task_no[[:space:]].*/$task_no	$new_task/" "$file"
        echo "Task $task_no updated."
    fi

# To undo task completion 
elif [[ "$1" == "-u" ]]; then
    read -p "Are you sure you wish to mark the task undone yes(y) or no(n) " choice
    if [[ "$choice" == "y" || -z "$choice"   ]]; then 
        if [[ -z "$2" ]]; then
            read -p "Enter the task number...:  " task_no
        else
            task_no="$2"
        fi

        if ! grep -q "^$task_no[[:space:]]" "$file"; then
            echo "Task doesn't exist. Enter a valid number."
            exit 1
        fi

        # sed -i "/^$task_no[[:space:]]/s/ (DONE)//" "$file"
        sed -i "/^$task_no[[:space:]]/s/ ✅//" "$file"

        echo "Task $task_no marked as incomplete."
    fi
 
# To clear contents of the file
elif [[ "$1" == "-c" ]]; then
    read -p "Are you sure you wish to clear the contents (y)yes (n)no?" choice
    if [[ "$choice" == "y" || -z "$choice" ]]; then
        truncate -s 0 $file
        echo "File cleared successfully."
    fi

# Task search
elif [[ "$1" == "-s" ]]; then 
    if [[ -z "$2" ]]; then 
        read -p "please enter the search key " task
    else
        task="$2"
    fi

    grep "$task" "$file"
    
    if [[ $? -eq 0 ]]; then 
        cat "$file" | grep "$task"
    else
        echo "Task not found"
    fi

# To clean up tasks
elif [[ "$1" == "-clean" ]]; then   
    cleanup_tasks
    echo "Cleaned up completed tasks"

# Help function 
elif [[ "$1" == "-h" ]] || [[ -z "$1" ]]; then
    usage

else
    echo "invalid argument"
fi

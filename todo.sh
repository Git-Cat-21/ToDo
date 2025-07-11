#!/bin/bash

file="$HOME/todo.txt"
hist_file="$HOME/history_todo.txt"
RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

ascii_art="
████████╗ ██████╗ ██████╗  ██████╗ 
╚══██╔══╝██╔═══██╗██╔══██╗██╔═══██╗
   ██║   ██║   ██║██║  ██║██║   ██║
   ██║   ██║   ██║██║  ██║██║   ██║
   ██║   ╚██████╔╝██████╔╝╚██████╔╝
   ╚═╝    ╚═════╝ ╚═════╝  ╚═════╝
"


usage() {
    echo -e "\n\033[1;37m---------------------------------------\033[0m"
    echo -e "\033[1;32m$ascii_art\033[0m"
    echo -e "\033[1;37m---------------------------------------\033[0m"
    echo -e "\033[1;33mA simple command-line tool to manage your to-do list\033[0m"
    echo
    echo -e "\033[1;36mUsage:\033[0m \033[1;37mtodo [OPTION] [<ARGUMENT>]\033[0m"
    echo
    echo -e "\033[1;35mOptions:\033[0m"
    echo -e "  \033[1;32m-a <task>\033[0m                 Add a new task to the list"
    echo -e "  \033[1;32m-d <task_num>\033[0m             Mark a specific task as done"
    echo -e "  \033[1;32m-l\033[0m                        List all tasks "
    echo -e "  \033[1;32m-r <task_num>\033[0m             Remove a specific task from the list"
    echo -e "  \033[1;32m-lp\033[0m                       List only the pending tasks"
    echo -e "  \033[1;32m-e <task_num> <new_task>\033[0m  Edit an existing task"
    echo -e "  \033[1;32m-u <task_num>\033[0m             Undo completion of a task"
    echo -e "  \033[1;32m-c\033[0m                        Clear all tasks from the list"
    echo -e "  \033[1;32m-s <keyword>\033[0m              Search for tasks containing a keyword"
    echo -e "  \033[1;32m-his\033[0m                      Show the entire history of tasks"
    echo -e "  \033[1;32m-clean\033[0m                    Clean up tasks marked as done"
    echo -e "  \033[1;32m-h\033[0m                        Display this help menu"
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

    if ! [ -z "$task" ]; then
        printf "%d\t%s\n" "$((line_no + 1))" "$task" >> "$file"
        printf "%d\t%s\t[%s]\t\n" "$((line_no_fh + 1))" "$task" "$(date)" >> "$hist_file"

        echo "Task entered successfully."
        reindex_tasks
    fi

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
    
    if ! [[ $? -eq 0 ]]; then 
        echo "Task not found"
    fi

# To list the contents of the history file
elif [[ "$1" == "-his" ]]; then
    cat "$hist_file"

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
# ToDo List Manager
[![starline](https://starlines.qoo.monster/assets/Git-Cat-21/ToDo)](https://github.com/Git-Cat-21/ToDo)
This is a simple Bash script to manage a todo list. The script allows you to add tasks, mark tasks as done, and list all tasks.

## Usage
```bash
git clone git@github.com:Git-Cat-21/ToDo.git
cd ToDo
chmod +x todo.sh
sudo cp ./todo.sh /usr/local/bin/todo
```

### To view help
```bash
todo
```

----

## Task Cleanup Instructions

### To automatically clean up tasks marked as done every Sunday at 2 PM:
> Open your crontab
```bash
crontab -e
```
> Add this line to your file
```bash
0 14 * * 0  /usr/local/bin/todo -clean
```

## Manual Cleanup

### To manually clean up completed tasks at any time, run: 
```bash
todo -clean
```

# Left ToDo
- [x] Add flag -r (remove tasks)
- [x] Add flag -h (help) 
- [x] Add flag -lp (list pending tasks)
- [ ] Add flag -R (random task)
- [x] Add flag -e (edit tasks)
- [x] Add flag -u (Undo Task Completion)
- [x] Add a search task functionality
- [x] Add a function that automatically deletes tasks that have been marked as done.
- [x] A history file to keep track of all the tasks

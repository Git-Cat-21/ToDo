# ToDo List Manager

This is a simple Bash script to manage a todo list. The script allows you to add tasks, mark tasks as done, and list all tasks.

## Usage
```bash
git clone git@github.com:Git-Cat-21/ToDo.git
cd ToDo
chmod +x todo.sh
```

### Add a Task
```bash
./todo.sh -a "Buy groceries"
```

### To list all tasks
```bash
./todo.sh -l
```

### Mark task as Done
```bash
./todo.sh -d <task number>
```

### To remove a task
```bash
./todo.sh -r <task number>
```

### To show only pending tasks
```bash
./todo.sh -lp
```

### To view help
```bash
./todo.sh -h
```

# Left ToDo
- [x] Add flag -r (remove tasks)
- [x] Add flag -h (help) 
- [x] Add flag -lp (list pending tasks)
- [ ] Add flag -R (random task)
- [x] Add flag -e (edit tasks)
- [ ] Add flag -u (Undo Task Completion )
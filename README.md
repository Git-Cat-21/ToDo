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

# Left ToDo
- [ ] Add flag -r (remove tasks)
- [ ] Add flag -h (help) 
- [ ] Add flag -R (random task)
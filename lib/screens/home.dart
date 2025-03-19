import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../constants/colors.dart';
import '../widgets/todo_item.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<ToDo> todosList = ToDo.todoList();
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();
  String selectedCategory = "Today"; // Default category
  DateTime? _selectedDeadline; // Holds selected deadline

  @override
  void initState() {
    _foundToDo = _filteredTasks();
    super.initState();
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(todo.isDone
            ? 'Task "${todo.todoText}" completed!'
            : 'Task "${todo.todoText}" marked incomplete.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Function to Pick Deadline
  void _pickDeadline(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDeadline = pickedDate;
      });
    }
  }

  // Function to Add Task with Deadline
  void _addToDoItem(String toDo) {
    if (toDo.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task cannot be empty!")),
      );
      return;
    }

    final newTask = ToDo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: toDo,
      todoText: toDo,
      deadline: _selectedDeadline, // Save user-selected deadline
    );

    setState(() {
      todosList.add(newTask);
      _selectedDeadline = null; // Reset deadline after adding task
    });

    _todoController.clear();
  }

  void _deleteToDoItem(String id) {
    final deletedTask = todosList.firstWhere((task) => task.id == id);

    setState(() {
      todosList.removeWhere((item) => item.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task "${deletedTask.todoText}" deleted!'),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              todosList.add(deletedTask);
            });
          },
        ),
      ),
    );
  }

  // Filters tasks based on the search query
  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];

    if (enteredKeyword.isEmpty) {
      results = _filteredTasks(); // Show all tasks if search is empty
    } else {
      results = _filteredTasks().where((todo) =>
          todo.todoText?.toLowerCase().contains(enteredKeyword.toLowerCase()) ??
          false).toList();
    }

    setState(() {
      _foundToDo = results; // Update displayed tasks
    });
  }

  // Returns tasks based on the selected category
  List<ToDo> _filteredTasks() {
    DateTime now = DateTime.now();

    return todosList.where((todo) {
      if (selectedCategory == "Today") {
        return todo.deadline != null &&
            todo.deadline!.day == now.day &&
            todo.deadline!.month == now.month &&
            todo.deadline!.year == now.year;
      } else if (selectedCategory == "Pending") {
        return todo.deadline == null || todo.deadline!.isAfter(now);
      } else if (selectedCategory == "Overdue") {
        return todo.deadline != null && todo.deadline!.isBefore(now);
      }
      return false;
    }).toList();
  }

  Widget _categoryButton(String category, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          selectedCategory = category;
          _foundToDo = _filteredTasks();
        });
      },
      icon: Icon(icon),
      label: Text(category),
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedCategory == category ? tdBlue : Colors.grey,
      ),
    );
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: const InputDecoration(
          hintText: 'Search tasks...',
          border: InputBorder.none,
          icon: Icon(Icons.search),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                searchBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _categoryButton("Today", Icons.today),
                    _categoryButton("Pending", Icons.pending),
                    _categoryButton("Overdue", Icons.error),
                  ],
                ),
                Expanded(
                  child: _buildTaskList(),
                ),
              ],
            ),
          ),
          _buildBottomInputBar(),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return Expanded(
      child: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex--;
            final task = todosList.removeAt(oldIndex);
            todosList.insert(newIndex, task);
          });
        },
        children: [
          for (var todo in _foundToDo)
            Dismissible(
              key: Key(todo.id!),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color: Colors.red,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) {
                _deleteToDoItem(todo.id!);
              },
              child: ToDoItem(
                todo: todo,
                onToDoChanged: _handleToDoChange,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomInputBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20, right: 10, left: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _todoController,
                      decoration: InputDecoration(
                        hintText: 'Enter a task...',
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => _todoController.clear(),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.grey),
                    onPressed: () => _pickDeadline(context),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: tdBlue,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(18),
            ),
            child: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              if (_todoController.text.trim().isNotEmpty) {
                _addToDoItem(_todoController.text);
              }
            },
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(title: const Text("TaskTastic"));

  Widget _buildDrawer() => Drawer();
}
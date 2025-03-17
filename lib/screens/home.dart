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

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _confirmDelete(ToDo todo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this task?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                setState(() {
                  todosList.remove(todo);
                  _foundToDo = List.from(todosList);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    _foundToDo = todosList;
    super.initState();
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: _todoController,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(Icons.search, color: Colors.black, size: 20),
          prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.grey),
        ),
        onChanged: (value) => _runFilter(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(), // Add Navigation Drawer
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
                    _categoryButton("Today"),
                    _categoryButton("Pending"),
                    _categoryButton("Overdue"),
                  ],
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 30, bottom: 10),
                        child: Text(
                          '$selectedCategory Tasks',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      for (ToDo todo in _foundToDo.reversed)
                        ToDoItem(
                          todo: todo,
                          onToDoChanged: _handleToDoChange,
                          onDeleteItem: _confirmDelete,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to filter tasks based on category
  List<ToDo> _filteredTasks() {
    DateTime now = DateTime.now();
    return todosList.where((todo) {
      if (selectedCategory == "Today") {
        return todo.deadline?.day == now.day &&
            todo.deadline?.month == now.month &&
            todo.deadline?.year == now.year;
      } else if (selectedCategory == "Pending") {
        return todo.deadline == null || todo.deadline!.isAfter(now);
      } else if (selectedCategory == "Overdue") {
        return todo.deadline != null && todo.deadline!.isBefore(now);
      }
      return false;
    }).toList();
  }

  Widget _categoryButton(String category) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedCategory = category;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedCategory == category ? tdBlue : Colors.grey[300],
        foregroundColor: selectedCategory == category ? Colors.white : Colors.black,
      ),
      child: Text(category),
    );
  }

  // Drawer Widget
  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("John Doe"), // Placeholder name
            accountEmail: const Text("johndoe@example.com"), // Placeholder email
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/avatar.jpeg'), // Profile Image
            ),
          ),
          ListTile(
            leading: const Icon(Icons.today),
            title: const Text("Today"),
            onTap: () {
              setState(() {
                selectedCategory = "Today";
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.pending_actions),
            title: const Text("Pending"),
            onTap: () {
              setState(() {
                selectedCategory = "Pending";
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.warning),
            title: const Text("Overdue"),
            onTap: () {
              setState(() {
                selectedCategory = "Overdue";
              });
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              // Navigate to settings screen (to be implemented)
            },
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: const Text("TaskTastic"),
    );
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((todo) =>
              todo.title!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundToDo = results;
    });
  }
}
import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../constants/colors.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final Function(ToDo) onToDoChanged;

  const ToDoItem({
    super.key,
    required this.todo,
    required this.onToDoChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15), // More compact layout
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onToDoChanged(todo), // Toggles task completion
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            decoration: BoxDecoration(
              color: todo.isDone ? Colors.green[100] : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  todo.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: todo.isDone ? Colors.green : tdBlue,
                  size: 28,
                ),
                const SizedBox(width: 12), // Space between icon and text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.todoText ?? "No title",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: todo.isDone ? Colors.grey : tdBlack,
                          decoration: todo.isDone ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      if (todo.deadline != null) // Show deadline if it exists
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(
                              _formatDeadline(todo.deadline!),
                              style: TextStyle(color: _getDeadlineColor(todo.deadline!)),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Formats the deadline date
  String _formatDeadline(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  // Determines the deadline color
  Color _getDeadlineColor(DateTime date) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    if (date.isBefore(today)) {
      return Colors.red; // Overdue
    } else if (date.isAtSameMomentAs(today)) {
      return Colors.orange; // Due today
    } else {
      return Colors.green; // Future deadline
    }
  }
}
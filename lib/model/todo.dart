class ToDo {
  String? id;
  String? title;
  String? todoText;
  bool isDone;
  DateTime? deadline;

  ToDo({
    required this.id,
    required this.title,
    required this.todoText,
    this.isDone = false,
    this.deadline,
  });

  static List<ToDo> todoList() {
    return [
      ToDo(id: '01', title: 'Exercise', todoText: 'Morning Exercise', isDone: true, deadline: DateTime(2025, 3, 16)),
      ToDo(id: '02', title: 'Shopping', todoText: 'Buy Groceries', isDone: true, deadline: DateTime(2025, 3, 17)),
      ToDo(id: '03', title: 'Emails', todoText: 'Check Emails'),
      ToDo(id: '04', title: 'Meeting', todoText: 'Team Meeting', deadline: DateTime(2025, 3, 18)),
      ToDo(id: '05', title: 'Development', todoText: 'Work on mobile apps for 2 hours'),
      ToDo(id: '06', title: 'Dinner', todoText: 'Team Dinner', deadline: DateTime(2025, 3, 19)),
    ];
  }
}
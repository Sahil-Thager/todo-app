class ToDo {
  final String? id;
  final String? todoText;
  bool isDone;
  final DateTime date;
  bool triggerNotification;

  ToDo({
    this.id,
    this.todoText,
    this.isDone = false,
    required this.date,
    this.triggerNotification = false,
  });
}

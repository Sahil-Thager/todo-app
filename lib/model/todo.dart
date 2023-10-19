class ToDo {
  final String id;
  final String? todoText;
  bool isDone;
  final DateTime date;
  bool triggerNotification10;
  bool triggerMyNotification;
  bool isNotificationTriggered;

  ToDo({
    required this.id,
    this.todoText,
    this.isDone = false,
    required this.date,
    this.triggerNotification10 = true,
    this.triggerMyNotification = true,
    this.isNotificationTriggered = false,
  });
}

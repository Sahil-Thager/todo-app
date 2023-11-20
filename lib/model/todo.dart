class ToDo {
  final String id;
  final String? todoText;
  bool isDone;
  final DateTime date;
  int notificationTriggerDuration;
  bool triggerMyNotification;
  bool isNotificationTriggered;

  ToDo({
    required this.id,
    this.todoText,
    this.isDone = false,
    required this.date,
    required this.notificationTriggerDuration,
    this.triggerMyNotification = true,
    this.isNotificationTriggered = false,
  });
}

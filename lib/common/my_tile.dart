import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/todo.dart';
import 'package:flutter_todo_app/notifications/notification_services.dart';
import 'package:flutter_todo_app/provider/todo_provider.dart';
import 'package:provider/provider.dart';

class MyTile extends StatefulWidget {
  const MyTile({
    super.key,
    required this.todo,
    this.onIconButtonTap,
    this.onTileTap,
    required this.icon,
    required this.myDecoration,
    required this.provider,
    required this.index,
  });

  final ToDo todo;
  final void Function()? onIconButtonTap;
  final void Function()? onTileTap;
  final IconData icon;
  final TextDecoration? myDecoration;
  final ToDoProvider provider;
  final bool index;

  @override
  State<MyTile> createState() => _MyTileState();
}

class _MyTileState extends State<MyTile> {
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    context.read<ToDoProvider>().toggleOffNotification(widget.todo.id);

    super.initState();

    sendNotification();
  }

  Timer? _timer;
  bool? isDone;

  void sendNotification() {
    final todo = widget.todo;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final timeDifference = widget.todo.date.difference(DateTime.now());

      if (timeDifference.inSeconds <= todo.notificationTriggerDuration &&
          !todo.isNotificationTriggered &&
          !widget.index) {
        notificationServices.sendNotification(
          widget.todo.todoText.toString(),
          widget.todo.date.toString(),
        );
        timer.cancel();
        log(widget.todo.id);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: widget.onTileTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: color.onInverseSurface,
        leading: Icon(
          widget.icon,
          color: color.onBackground,
        ),
        title: Text(
          widget.todo.todoText ?? 'na',
          style: TextStyle(
            fontSize: 16,
            color: color.onBackground,
            decoration: widget.myDecoration,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.symmetric(
            vertical: 12,
          ),
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            color: Colors.white,
            iconSize: 18,
            icon: const Icon(Icons.delete),
            onPressed: widget.onIconButtonTap,
          ),
        ),
        subtitle: Text(widget.todo.date.toString()),
      ),
    );
  }
}

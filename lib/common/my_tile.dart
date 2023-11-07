import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constants/colors.dart';
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
  });

  final ToDo todo;
  final void Function()? onIconButtonTap;
  final void Function()? onTileTap;
  final IconData icon;
  final TextDecoration? myDecoration;

  @override
  State<MyTile> createState() => _MyTileState();
}

class _MyTileState extends State<MyTile> {
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    notificationServices.intialiseNotification();
    context.read<ToDoProvider>().toggleOffNotification(widget.todo.id);

    super.initState();

    notificationOn10minutes(() {
      notificationServices.sendNotification(
          widget.todo.todoText.toString(), widget.todo.date.toString());
    });
    notificationOn1Hour(() {
      notificationServices.sendNotification(
          widget.todo.todoText.toString(), widget.todo.date.toString());
    });
    notificationOn1Day(() {
      notificationServices.sendNotification(
          widget.todo.todoText.toString(), widget.todo.date.toString());
    });
  }

  void notificationOn10minutes(VoidCallback callback) {
    final todo = widget.todo;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      final timeDifference = widget.todo.date.difference(DateTime.now());

      if (timeDifference.inSeconds <= 600 &&
          todo.triggerNotification10 == false) {
        callback.call();
        timer.cancel();
      }
    });
  }

  void notificationOn1Hour(VoidCallback callback) {
    final todo = widget.todo;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      final timeDifference = widget.todo.date.difference(DateTime.now());

      if (timeDifference.inSeconds <= 3600 &&
          todo.triggerNotification10 == false) {
        callback.call();
        timer.cancel();
      }
    });
  }

  void notificationOn1Day(VoidCallback callback) {
    final todo = widget.todo;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      final timeDifference = widget.todo.date.difference(DateTime.now());

      if (timeDifference.inSeconds <= 86400 &&
          todo.triggerNotification10 == false) {
        callback.call();
        timer.cancel();
      }
    });
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
            color: tdRed,
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

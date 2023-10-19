import 'package:cloud_firestore/cloud_firestore.dart';

class Variables {
  final String? id;

  final bool isDone;
  final bool notificationTrigger10;
  final String? time;
  final Timestamp? timestamp;
  final String? title;

  Variables({
    this.id,
    this.isDone = false,
    this.notificationTrigger10 = false,
    this.title,
    this.time,
    this.timestamp,
  });
  factory Variables.fromJson(Map<String, dynamic> json) {
    return Variables(
      isDone: json['isDone'],
      notificationTrigger10: json['notificationTrigger10'],
      title: json['title'],
      time: json['time'],
      timestamp: json['timestamp'],
    );
  }
}

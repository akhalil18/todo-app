import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Task {
  final String taskId;
  final String taskTitle;
  final DateTime date;
  // final String time;
  bool isDone;

  Task({
    this.taskId,
    @required this.taskTitle,
    @required this.date,
    // @required this.time,
    this.isDone = false,
  });

  factory Task.fromDocument(DocumentSnapshot doc) {
    Timestamp date = doc['date'];

    return Task(
      taskId: doc.documentID,
      taskTitle: doc['taskTitle'],
      date: date.toDate(),
      // time: doc['time'],
      isDone: doc['isDone'],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> task = {};
    task['taskTitle'] = this.taskTitle;
    task['date'] = this.date;
    // task['time'] = this.time;
    task['isDone'] = this.isDone;

    return task;
  }
}

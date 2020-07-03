import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/task.dart';

class TasksService {
  final tasksRef = Firestore.instance.collection('tasks');

  /// Add new task to firestor.
  /// Return true if success and false if fail.
  Future<bool> addTaskToFirestore(String userId, Task task) async {
    try {
      await tasksRef.document(userId).collection('userTasks').add(task.toMap());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// Fetch all tasks from firestore.
  /// Return Tasks List.
  Future<List<Task>> fetchAllTasks(String userId) async {
    List<Task> tasksList;
    try {
      final snapshot = await tasksRef
          .document(userId)
          .collection('userTasks')
          .orderBy('date', descending: false)
          .getDocuments();
      final tasks =
          snapshot.documents.map((d) => Task.fromDocument(d)).toList();
      tasksList = tasks;
    } catch (e) {
      print(e);
    }

    return tasksList;
  }

  /// Tasks stream.
  Stream<QuerySnapshot> tasksStream(String userId) {
    return tasksRef
        .document(userId)
        .collection('userTasks')
        .orderBy('date', descending: false)
        .snapshots()
        .skip(1);
  }

  /// Update task in firestore.
  /// Return true if success and false if fail.
  Future<bool> updateTask(
      {@required String userId, @required Task updatedTask}) async {
    try {
      final snapshot = await tasksRef
          .document(userId)
          .collection('userTasks')
          .document(updatedTask.taskId)
          .get();

      if (snapshot.exists) {
        snapshot.reference.updateData(updatedTask.toMap());
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// Delete task from firestore.
  /// Return true if success and false if fail.
  Future<bool> deleteTask(
      {@required String userId, @required String taskId}) async {
    try {
      final snapshot = await tasksRef
          .document(userId)
          .collection('userTasks')
          .document(taskId)
          .get();

      if (snapshot.exists) {
        snapshot.reference.delete();
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// Change task statue, finished or not.
  /// Return true if success and false if fail.
  Future<bool> handleFinishedTask({
    @required String userId,
    @required String taskId,
    @required bool oldStatus,
  }) async {
    bool changedStatue = !oldStatus;
    try {
      final snapshot = await tasksRef
          .document(userId)
          .collection('userTasks')
          .document(taskId)
          .get();

      if (snapshot.exists) {
        snapshot.reference.updateData({'isDone': changedStatue});
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

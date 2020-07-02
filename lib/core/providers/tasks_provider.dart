import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/tasks_service.dart';

class TasksProvider with ChangeNotifier {
  List<Task> _tasks;
  final _tasksService = TasksService();

  List<Task> get tasks {
    return _tasks != null ? [..._tasks] : null;
  }

  String get finishedTasks {
    final completedTasks = tasks.where((task) => task.isDone).length;
    final allTasks = tasks.length;
    return '$completedTasks/$allTasks';
  }

  void listenToTasks(String userId) {
    var tasksStream = _tasksService.tasksStream(userId);
    tasksStream.listen((tasksSnapshot) {
      var tasks =
          tasksSnapshot.documents.map((d) => Task.fromDocument(d)).toList();
      _tasks = tasks;
      notifyListeners();
    });
  }

  Future<void> fetchTasks(String userId) async {
    final tasksList = await _tasksService.fetchAllTasks(userId);
    if (tasksList != null) {
      _tasks = tasksList;
    }
  }

  Future<bool> addTask(String userId, Task task) async {
    bool isAded = await _tasksService.addTaskToFirestore(userId, task);
    if (isAded) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteTask({String userId, String taskId}) async {
    bool isDeleted =
        await _tasksService.deleteTask(userId: userId, taskId: taskId);
    if (isDeleted) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateTask({String userId, Task updatedTask}) async {
    bool isUpdated = await _tasksService.updateTask(
        userId: userId, updatedTask: updatedTask);

    if (isUpdated) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateFinishedTask(
      {@required String userId,
      @required String taskId,
      @required bool oldStatus}) async {
    bool isUpdated = await _tasksService.handleFinishedTask(
        userId: userId, taskId: taskId, oldStatus: oldStatus);

    if (isUpdated) {
      return true;
    } else {
      return false;
    }
  }
}

import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/tasks_service.dart';

// Povide fetched task to ui, and update ui if there is any chang in tasks.

class TasksProvider with ChangeNotifier {
  List<Task> _tasks;
  final _tasksService = TasksService();

  /// User tasks.
  List<Task> get tasks {
    return _tasks != null ? [..._tasks] : null;
  }

  /// Finished tasks counter.
  String get finishedTasksCounter {
    final completedTasks = tasks.where((task) => task.isDone).length;
    final allTasks = tasks.length;
    return '$completedTasks/$allTasks';
  }

  /// Listen to any change in tasks.
  /// Update ui.
  void listenToTasks(String userId) {
    var tasksStream = _tasksService.tasksStream(userId);
    tasksStream.listen((tasksSnapshot) {
      var tasks =
          tasksSnapshot.documents.map((d) => Task.fromDocument(d)).toList();
      _tasks = tasks;
      notifyListeners();
    });
  }

// Implement fetch task service and update task list.
  Future<void> fetchTasks(String userId) async {
    final tasksList = await _tasksService.fetchAllTasks(userId);
    if (tasksList != null) {
      _tasks = tasksList;
    }
  }

  /// Implement add Task service.
  /// Return true if success, false if fail.
  Future<bool> addTask(String userId, Task task) async {
    bool isAded = await _tasksService.addTaskToFirestore(userId, task);
    if (isAded) {
      return true;
    } else {
      return false;
    }
  }

  /// Implement delete Task service.
  /// Return true if success, false if fail.
  Future<bool> deleteTask({String userId, String taskId}) async {
    bool isDeleted =
        await _tasksService.deleteTask(userId: userId, taskId: taskId);
    if (isDeleted) {
      return true;
    } else {
      return false;
    }
  }

  /// Implement update Task service.
  /// Return true if success, false if fail.
  Future<bool> updateTask({String userId, Task updatedTask}) async {
    bool isUpdated = await _tasksService.updateTask(
        userId: userId, updatedTask: updatedTask);
    if (isUpdated) {
      return true;
    } else {
      return false;
    }
  }

  /// Implement change task statue serfice, finished or not.
  /// Return true if success and false if fail.
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

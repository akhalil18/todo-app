import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/task.dart';
import '../../core/providers/tasks_provider.dart';
import '../../core/models/task_helper.dart';
import 'add_task_bottom_sheet.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final String userId;
  TaskCard({@required this.task, @required this.userId});

  @override
  Widget build(BuildContext context) {
    final tasksProvider = Provider.of<TasksProvider>(context, listen: false);

    bool isFinished = task.isDone;
    String date = getDate(task.date);

    return Dismissible(
      key: ValueKey(task.taskId),
      direction: DismissDirection.endToStart,
      background: dismissIcon(),
      confirmDismiss: (direction) => buildDeleteTaskDialog(context),

      //delete task
      onDismissed: (direction) => deleteTask(
          id: task.taskId,
          provider: tasksProvider,
          currentUserId: userId,
          context: context),

      // task body
      child: Card(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          onLongPress: () => handleFinishedTask(context, tasksProvider),
          leading: IconButton(
            icon: isFinished
                ? Icon(Icons.check_box)
                : Icon(Icons.check_box_outline_blank),
            onPressed: () => handleFinishedTask(context, tasksProvider),
          ),
          title: Text(
            task.taskTitle,
            style: TextStyle(
                decoration: isFinished
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          ),
          subtitle: Text(date),
          trailing: IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () => showTaskDialog(context, tasksProvider),
          ),
        ),
      ),
    );
  }

  Future<bool> buildDeleteTaskDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          'Delet Task !',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        content: Text('Are you sure you want to delete this Task ?'),
        actions: <Widget>[
          FlatButton(
            child: Text("Yes"),
            onPressed: () {
              Navigator.of(ctx).pop(true);
            },
          ),
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
          ),
        ],
      ),
    );
  }

  // delete task from firestore
  Future<void> deleteTask(
      {String id,
      String currentUserId,
      TasksProvider provider,
      BuildContext context}) async {
    bool isDeleted =
        await provider.deleteTask(taskId: id, userId: currentUserId);
    if (isDeleted) {
      showSnack('Task deleted', context);
    } else {
      showSnack('Ooops..something wrong, try one more time', context);
    }
  }

  // dismissible background icon
  Container dismissIcon() {
    return Container(
      padding: EdgeInsets.only(right: 30.0),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      alignment: Alignment.centerRight,
      child: Icon(
        Icons.delete_forever,
        size: 50,
        color: Colors.red,
      ),
    );
  }

  // change task statue finished or not
  void handleFinishedTask(BuildContext context, TasksProvider tasksProvider) {
    tasksProvider
        .updateFinishedTask(
            userId: userId, taskId: task.taskId, oldStatus: task.isDone)
        .then((isUpdated) {
      if (isUpdated) {
        if (!task.isDone) showSnack('Completed', context);
      } else {
        showSnack('Ooops..something wrong, try one more time', context);
      }
    });
  }

  // show edit or delete task dailog
  void showTaskDialog(BuildContext context, TasksProvider tasksProvider) {
    showDialog(
        context: context,
        builder: (ctx) => SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              children: <Widget>[
                SimpleDialogOption(
                  child: Text('Edit'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    showEditTaskBottomSheet(context, tasksProvider);
                  },
                ),
                SimpleDialogOption(
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    deleteTask(
                        provider: tasksProvider,
                        context: context,
                        currentUserId: userId,
                        id: task.taskId);
                  },
                ),
              ],
            ));
  }

  Future<void> showEditTaskBottomSheet(
      BuildContext context, TasksProvider tasksProvider) async {
    showModalBottomSheet(
        context: context,
        builder: (ctx) => AddTaskBottomSheet(
              // edit task callback
              ({Task addedTask}) async {
                Navigator.of(context).pop();
                var isEdited = await tasksProvider.updateTask(
                    userId: this.userId, updatedTask: addedTask);
                // check if task edited successfully
                if (isEdited) {
                  showSnack('Task edited successfully', context);
                } else {
                  showSnack(
                      'Ooops..something wrong, try one more time', context);
                }
              },
              oldTask: this.task,
            ));
  }

  void showSnack(String title, BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(title),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

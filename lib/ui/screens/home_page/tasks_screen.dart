import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/task.dart';
import '../../../core/models/user.dart';
import '../../../core/providers/tasks_provider.dart';
import '../../widgets/add_task_bottom_sheet.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/taskCrad.dart';

class TasksScreen extends StatefulWidget {
  final User currentUser;
  TasksScreen({@required this.currentUser});
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeTasks(context);
  }

  // fetch tasks and start listening to tasks stream
  Future<void> initializeTasks(BuildContext context) async {
    final taskProvider = Provider.of<TasksProvider>(context, listen: false);
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      await taskProvider.fetchTasks(widget.currentUser.id).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      // listen to any task change
      taskProvider.listenToTasks(widget.currentUser.id);
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        foregroundColor:
            Theme.of(context).floatingActionButtonTheme.foregroundColor,
        child: Icon(Icons.add),
        onPressed: () {
          addTask(context);
        },
      ),
      drawer: AppDrawer(widget.currentUser),
      appBar: AppBar(
        centerTitle: true,
        title: Text('My Tasks'),
      ),
      body: _isLoading ? buildLoadingScreen() : buildTasksScreen(),
    );
  }

  // loading screen
  Center buildLoadingScreen() => Center(child: CircularProgressIndicator());

  // tasks screen
  Consumer<TasksProvider> buildTasksScreen() {
    return Consumer<TasksProvider>(builder: (context, tasksProvider, ch) {
      if (tasksProvider.tasks == null) {
        return Center(child: Text('Ooops..something wrong, try again later'));
      } else if (tasksProvider.tasks.isEmpty) {
        return buildNoTodoScreen();
      } else {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                buildHeader(tasksProvider.finishedTasksCounter),
                builTasksList(tasksProvider.tasks),
              ],
            ),
          ),
        );
      }
    });
  }

  Center buildNoTodoScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/relax.png',
            height: 200,
          ),
          Text(
            "You're all done for today!\n Enjoy your day.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Container buildHeader(String finishedTasks) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Completed Tasks',
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
          ),
          Text(
            finishedTasks,
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Container builTasksList(List<Task> tasks) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: tasks
            .map((t) => TaskCard(
                  task: t,
                  userId: widget.currentUser.id,
                ))
            .toList(),
      ),
    );
  }

  // ad new task function
  void addTask(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => AddTaskBottomSheet(addTaskCallback),
    );
  }

  Future<void> addTaskCallback({Task addedTask}) async {
    Navigator.of(context).pop();
    var isAded = await Provider.of<TasksProvider>(context, listen: false)
        .addTask(widget.currentUser.id, addedTask);

    if (isAded) {
      showSnack('New task aded');
    } else {
      showSnack('Ooops..something wrong, try one more time');
    }
  }

  void showSnack(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ));
  }
}

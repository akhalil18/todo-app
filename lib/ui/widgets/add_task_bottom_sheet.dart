import 'package:flutter/material.dart';

import '../../core/models/task.dart';
import '../../core/models/task_helper.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final Task oldTask;
  final Future<void> Function({Task addedTask}) addOrEditTask;
  AddTaskBottomSheet(this.addOrEditTask, {this.oldTask});

  @override
  _AddTaskBottomSheetState createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  DateTime selectedDate;
  TimeOfDay selectedTime;
  bool hasError = false;
  String errorMessage;

  TextEditingController _taskController;

  @override
  void initState() {
    super.initState();
    initializeData(widget.oldTask);
  }

  // Initialize task date and time.
  void initializeData(Task oldTask) {
    if (oldTask == null) {
      selectedDate = DateTime.now();
      selectedTime = TimeOfDay(hour: 0, minute: 0);
      _taskController = TextEditingController();
    } else {
      selectedDate = oldTask.date;
      selectedTime =
          TimeOfDay(hour: selectedDate.hour, minute: selectedDate.minute);
      _taskController = TextEditingController(text: oldTask.taskTitle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 15,
        right: 15,
        left: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom + 15,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildTaskTextField(),
            buildDateTimeRow(),
            SizedBox(
              height: 10,
            ),
            buildSubmitButton()
          ],
        ),
      ),
    );
  }

  TextField buildTaskTextField() {
    return TextField(
      controller: _taskController,
      autofocus: true,
      maxLines: null,
      decoration: InputDecoration(
          errorText: hasError ? errorMessage : null,
          isDense: true,
          border: InputBorder.none,
          hintText: 'e.g.Read new book'),
    );
  }

  Row buildDateTimeRow() {
    return Row(
      children: <Widget>[
        FlatButton.icon(
          label: Text('Date'),
          icon: Icon(Icons.date_range),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: _datePicker,
        ),
        FlatButton.icon(
          label: Text('Time'),
          icon: Icon(Icons.watch_later),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: _timePicker,
        ),
        Spacer(),
        Text(getDate(DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, selectedTime.hour, selectedTime.minute)))
      ],
    );
  }

  RaisedButton buildSubmitButton() {
    return RaisedButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      elevation: 0.0,
      child: Text('Save'),
      onPressed: () async {
        // If task field is empty show error.
        if (_taskController.text.isEmpty) {
          errorMessage = 'Task field is empty!';
          setState(() {
            hasError = true;
          });
          return;
        }

        // Add or edit task callback
        widget.addOrEditTask(
          addedTask: Task(
            taskTitle: _taskController.text,
            isDone: widget.oldTask?.isDone ?? false,
            taskId: widget.oldTask?.taskId,
            date: DateTime(selectedDate.year, selectedDate.month,
                selectedDate.day, selectedTime.hour, selectedTime.minute),
          ),
        );
        _taskController.clear();
      },
    );
  }

  // Pick date.
  void _datePicker() {
    FocusScope.of(context).requestFocus(FocusNode());
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 7)),
    ).then((date) {
      if (date == null) {
        return;
      }
      setState(() {
        selectedDate = date;
      });
    });
  }

  // Pick time.
  void _timePicker() {
    FocusScope.of(context).requestFocus(FocusNode());
    showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 0, minute: 0),
    ).then((time) {
      if (time == null) {
        return;
      }
      setState(() {
        selectedTime = time;
      });
    });
  }
}

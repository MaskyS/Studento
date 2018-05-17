import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TaskItem {

  /// The unique Id of each [TaskItem].
  int taskId;

  /// The main title of the [TaskItem].
  final String title;

  /// Status of item.
  bool complete;

  /// The time before which user has to complete the [TaskItem]. If not
  /// completed by then, then we should classify this to-do as
  final DateTime dueDate;

  TaskItem({this.taskId, this.title, this.complete = false, this.dueDate});
}

class TaskItemWidget extends StatelessWidget {
  final String title;
  final VoidCallback deleteTask;
  final VoidCallback completeTask;

  TaskItemWidget({this.title, this.deleteTask, this.completeTask});

  Widget _buildDissmissibleBackground(
    {Color color,
      IconData icon,
      FractionalOffset align = FractionalOffset.centerLeft}) =>
    new Container(
      height: 42.0,
      color: color,
      child: new Icon(icon, color: Colors.white70),
      alignment: align,
    );

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.all(5.0),
      color: Colors.grey,
      height: 42.0,
      child: new Dismissible(
        direction: DismissDirection.horizontal,
        child: new Align(
          alignment: FractionalOffset.centerLeft,
          child: new Padding(
            padding: new EdgeInsets.all(10.0), child: new Text(title))),
        key: new Key(title),
        background: _buildDissmissibleBackground(
          color: Colors.lime, icon: Icons.check),
        secondaryBackground: _buildDissmissibleBackground(
          color: Colors.red,
          icon: Icons.delete,
          align: FractionalOffset.centerRight),
        onDismissed: (direction) => direction == DismissDirection.startToEnd
          ? completeTask()
          : deleteTask(),
        ),
      );
  }
}
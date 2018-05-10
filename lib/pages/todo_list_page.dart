import 'package:flutter/material.dart';
import '../UI/studento_app_bar.dart';
import 'package:flutter/foundation.dart';



class ToDoItem extends StatelessWidget {
  /// The main title of the [ToDoItem].
  final String title;

  /// Optional extra details about the [ToDoItem].
  final String details;

  /// The time before which user has to complete the [ToDoItem]. If not
  /// completed by then, then we should classify this to-do as
  final DateTime dueDate;

  /// The category of the [ToDoItem]. This can be one of the user's subjects,
  /// or a custom category created by the user. We can use this to sort and
  /// color-code the [ToDoItem]s.
  final String category;
  ToDoItem(
      {@required this.title, @required this.dueDate, @required this.category, this.details});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (DragStartDetails dragStartDetails) => _dismissItem(dragStartDetails),
      child: ListTile(
        title: new Text(title),
        subtitle: new Text(
          details,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: CircleAvatar(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          radius: 16.0,
          child: Text(
            "${dueDate.day}",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        isThreeLine: true,
        onTap: () => _showDetailsOfItem(context),
      ),
    );
  }

  void _showDetailsOfItem(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Details"),
          contentPadding: const EdgeInsets.all(20.0),
          children: <Widget>[
            Center(
              widthFactor: 50.0,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        );
      });
  }

  void _dismissItem(DragStartDetails details) {
    print(details.globalPosition);
    toDoList.removeWhere((item) => item.title == title);
  }
}

List<ToDoItem> toDoList = [
  ToDoItem(
    title: "Get Dressed",
    details: "I need to get dressed",
    dueDate: new DateTime.now(),
    category: 'Life',
  ),
  ToDoItem(
    title: "Brush Teeth",
    details: "Up and down, left and right, we brush, \nwe brush, we brush. It is a true joy, to brush.",
    dueDate: new DateTime(2018),
    category: 'Routine',
  ),
];

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => new _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  GlobalKey dialogKey = GlobalKey();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StudentoAppBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[700],
        child: Icon(Icons.add),
        onPressed: () => _addTask(context),
      ),
      body: ListView(
        children: toDoList,
      ),
    );
  }

  /// This will show a [SimpleDialog] where user can enter details of a new
  /// [ToDoItem]
  void _addTask(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text("Create new Task"),
            contentPadding: const EdgeInsets.all(20.0),
            children: <Widget>[
              Text("This is where we need to enter details"),
              TextField(
              ),
              SimpleDialogOption(
                child: RaisedButton(
                  shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  color: Colors.blue[700],
                  onPressed: () {
                    Navigator.pop(context);
                    saveTask();
                  },
                  child: Text(
                    "SAVE",
                    style: const TextStyle(
                      color: Colors.white,
                    )
                  ),
                ),
              ),
            ],
          );
        });
    print("This will add a new task");
  }

  void saveTask(/*ToDoItem toDoItem*/) {
    setState(() {
      //toDoList.add(/*toDoItem*/);
    });
    print("Task has been saved");
  }
}



import 'package:flutter/material.dart';
import '../model/class.dart';
import '../util/schedule_database_client.dart';
import '../UI/add_recess_dialog.dart';

class ClassWidget extends StatefulWidget {

  ClassWidget(this.classItem);

  Class classItem;

  @override
  _ClassWidgetState createState() => _ClassWidgetState();
}

class _ClassWidgetState extends State<ClassWidget> {

  Duration timeLeftInClass;
  bool isClassCurrentlyOngoing;

  TextEditingController nameController;
  TextEditingController locationController;
  TextEditingController teacherController;

  var db = ScheduleDatabaseHelper();

  void initTextControllers(){
    nameController = TextEditingController(text: widget.classItem.name ?? '');
    locationController = TextEditingController(text: widget.classItem.location ?? '');
    teacherController = TextEditingController(text: widget.classItem.teacher ?? '');
  }

  @override
  void initState() {
    initTextControllers();
    super.initState();
  }

  @override
  void dispose(){
    nameController.dispose();
    super.dispose();
  }

  void checkIfClassCurrentlyOngoing() {

    isClassCurrentlyOngoing = getIsClassCurrentlyOnGoing(
      widget.classItem.startTime,
      widget.classItem.endTime
    );

    if (isClassCurrentlyOngoing) {
      timeLeftInClass = getTimeLeftInClass(
        widget.classItem.startTime,
        widget.classItem.endTime
      );
    }
  }

  Duration getTimeLeftInClass(DateTime start, DateTime end) {
    /// DateTime class doesn't have a setter for [hour],
    /// so use this var for doing the maths instead.
    int startHours = start.hour;

    /// DateTime class doesn't have a setter for [minute],
    /// so use this var for doing the maths instead.
    int startMinutes = start.minute;

    if (end.minute > start.minute) {
      --startHours;
      startMinutes += 60;
    }

    var diffMinutes = startMinutes - end.minute;
    var diffHours = startHours - end.hour;

    return Duration(hours: diffHours, minutes: diffMinutes);
  }

  bool getIsClassCurrentlyOnGoing(DateTime start, DateTime end) {
    var currentTime = DateTime.now();

    if (
      start.hour >= currentTime.hour
        && end.hour <= currentTime.hour
    ) {
      if (
        start.minute >= currentTime.minute
          && end.minute <= currentTime.hour
      ) {
        return true;
      }
    }

    return false;
  }

  String getTimeLeftString(Duration timeLeft) {
    String msg = "Ends in ";
    if (timeLeft.inHours > 0) msg += "${timeLeft.inHours} hrs & ";
    msg += "${timeLeft.inMinutes} mins";

    return msg;
  }

  Widget buildSubtitle() {
    List<Widget> columnChildren = [
      Row(
        children: <Widget>[
        Text(widget.classItem.location ?? ''),
        Padding(padding: EdgeInsets.only(left: 40.0),),
        Text(widget.classItem.teacher ?? ''),
      ]),
    ];

    if (isClassCurrentlyOngoing) {
      columnChildren.add(
        Padding(padding: EdgeInsets.only(top: 5.0)));
      columnChildren.add(
        Row(
          children: <Widget>[
            Text(
              getTimeLeftString(timeLeftInClass),
              textScaleFactor: 0.8,
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: columnChildren
    );
  }

  void showEditDialog() {

    showDialog(context: context, builder: (_) {
      return AlertDialog(
        title: Text("Edit Class"),
        content: SingleChildScrollView(child: Column(children: <Widget>[
          ListTile(
            leading: Text("Name"),
            title: TextField(
              keyboardType: TextInputType.text,
              controller: nameController,
              maxLength: 20,
            ),
          ),
          ListTile(
            leading: Text("Location"),
            title: TextField(
              keyboardType: TextInputType.text,
              controller: locationController,
            ),
          ),
          ListTile(
            leading: Text("Teacher"),
            title: TextField(
              keyboardType: TextInputType.text,
              controller: teacherController,
            ),
          ),
          FlatButton.icon(
            icon: Icon(Icons.delete),
            color: Colors.redAccent,
            label: Text("Delete Class"),
            onPressed: deleteClass,
          ),
        ],)),
        actions: <Widget>[
          FlatButton(
            child: Text("CANCEL"),
            textColor: Colors.redAccent,
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            child: Text("SAVE"),
            textColor: Colors.lightGreen,
            onPressed: updateClass,
          ),
        ],
      );
    });
  }

  void updateClass() async{
    setState(() {
      widget.classItem
        ..name = nameController.text
        ..location = locationController.text
        ..teacher = teacherController.text;
    });

    bool doesClassExist =
        (await db.getClass(widget.classItem.id) != null);

    if (doesClassExist) {
      db.updateClass(widget.classItem);
    }
    else {
      /// TODO Start Times/End Times should also be set here.
      /// TODO Calculate that based on school start/end times
      /// TODO + no of Classes + length of classes.
      int _id = await db.addClass(widget.classItem);
      setState(() => widget.classItem.id = _id);
    }
    Navigator.of(context).pop();
  }

  void deleteClass() {
    setState(() {
      widget.classItem.name = "You haven't set this class yet.";
      widget.classItem.location = null;
      widget.classItem.teacher = null;
    });

    db.deleteClass(widget.classItem.id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    checkIfClassCurrentlyOngoing();
    Widget editButton = IconButton(
      icon: Icon(Icons.edit),
      onPressed: () async {
        if (widget.classItem.weekDay == 0) {
          Class updatedRecess = await Navigator
              .of(context)
              .push(MaterialPageRoute<Class>(
                builder: (_) => AddRecessDialog.edit(widget.classItem),
                fullscreenDialog: true
              ));
          if (updatedRecess != null) {
            updatedRecess.id = widget.classItem.id;
            setState(() => widget.classItem  = updatedRecess);
            db.updateClass(updatedRecess);
            // ? This is a super hack, The right was to do this is to
            // ? update the parent widget (ClassesList) but the current
            // ? implementation doesn't allow that.
            Navigator
                .of(context)
                .pushReplacementNamed('schedule_page');
          }
        }
          else {
            showEditDialog();
        }
      }
    );

    return ListTile(
      enabled: true,
      isThreeLine: true,
      selected: isClassCurrentlyOngoing,
      subtitle: buildSubtitle(),
      trailing: editButton,
      onTap: () => print("hi"),
      leading: Container(
        height: 55.0,
        width: 55.0,
        child: Center(
          child: Text(widget.classItem.classNo.toString())),
        color:
            (isClassCurrentlyOngoing)
              ? Theme.of(context).primaryColor
              : Colors.greenAccent),
      title: Text(
        widget.classItem.name,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
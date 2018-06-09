import 'package:quiver/core.dart';
import 'package:flutter/material.dart';

class TodoItem extends StatelessWidget {
  String _itemName;
  String _dueDate;
  String _details;
  bool isComplete;
  int _id;

  TodoItem(
    this._itemName,
    this._dueDate,
    this._details,
    {this.isComplete}
  );

  bool operator ==(Object todoItem) =>
    identical(this, todoItem) ||
      todoItem is TodoItem &&
        itemName == todoItem.itemName &&
        dueDate == todoItem.dueDate &&
        details == todoItem.details &&
        id == todoItem.id &&
        isComplete == todoItem.isComplete;

  int get hashCode =>
      hash4(itemName.hashCode, dueDate.hashCode, details.hashCode, id.hashCode);

  TodoItem.map(dynamic obj) {
    this._itemName = obj["itemName"];
    this._details = obj["details"];
    this._dueDate = obj["dueDate"];
    this.isComplete == (obj["isComplete"] == 1) ? true : false;
    this._id = obj["id"];
  }

  String get itemName => _itemName;
  String get details => _details;
  String get dueDate => _dueDate;
  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["itemName"] = _itemName;
    map["details"] = _details;
    map["dueDate"] = _dueDate;
    map["isComplete"] = isComplete == true ? 1 : 0;
    map["id"] = _id ?? _id;

    return map;
  }

  TodoItem.fromMap(Map<String, dynamic> map) {
    this._itemName = map["itemName"];
    this._details = map["details"];
    this._dueDate = map["dueDate"];
    this.isComplete = (map["isComplete"] == 1) ? true : false;
    this._id = map["id"];
  }

  @override
  Widget build(BuildContext context) {
    String _tooltip = (isComplete)
        ? "Swipe to remove this item."
        : "Swipe right to mark this task as complete, or left to delete it.";

    final DateTime dateNow = DateTime.now();
    Duration timeLeft = DateTime.parse(dueDate).difference(dateNow);
    Color timeLeftTextColor = Colors.black87;
    String timeLeftString = ' ';

    if (timeLeft.inDays > 0) timeLeftString = "${timeLeft.inDays} day";
      else if (timeLeft.inHours > 0) timeLeftString = "${timeLeft.inHours} hour";
        else if (timeLeft.inMinutes > 0) {
          timeLeftString = "${timeLeft.inMinutes} minute";
          timeLeftTextColor = Colors.redAccent;
        }

    /// Add 's' if the no of days, months, whatever is more than 1
    int durationLeft = int.tryParse(timeLeftString.split(" ")[0]); // e.g value: 12
    String timeUnit = timeLeftString.split(" ")[1]; // e.g value: "day"
    if (durationLeft != null) {

      if (durationLeft > 1) timeUnit += 's'; // for e.g, "day" becomes "days".
      timeLeftString = "$durationLeft $timeUnit left";
    }
    print("$timeLeftString hello");
    return Container(
      child: Tooltip(
        message: _tooltip,
        child: ListTile(
          onTap: () {
            //TODO Implement TODO View Details.
            // We probably want a modal bottom sheet in here.
            print("You tapped the Todo with $id");
          },
          title: Text(_itemName, textScaleFactor: 1.1,),
          leading: CircleAvatar(
            backgroundColor: Colors.deepPurpleAccent,
            radius: 4.0,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                _details,
                textScaleFactor: 1.1,
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.timer,
                size: 12.0,
              ),
              Padding(
                padding: EdgeInsets.only(right: 5.0),
              ),
              Text(
                timeLeftString,
                style: TextStyle(
                  color: timeLeftTextColor,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

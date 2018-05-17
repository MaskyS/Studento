import 'package:quiver/core.dart';
import 'package:flutter/material.dart';

class TodoItem extends StatelessWidget {
  String _itemName;
  String _dueDate;
  String _details;
  bool isComplete;
  int _id;

  TodoItem(this._itemName, this._dueDate, this._details, {this.isComplete});

  bool operator ==(todoItem) =>
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
    var map = new Map<String, dynamic>();
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
    String _tooltip = (isComplete == true)
        ? "Swipe to remove this item."
        : "Swipe right to mark this task as complete, or left to delete it.";
    return Container(
        child: Tooltip(
      message: _tooltip,
      child: ListTile(
          isThreeLine: true,
          onTap: () {
            print("You tapped the Todo with $id");
          },
          leading: CircleAvatar(
            backgroundColor: Colors.deepPurpleAccent,
            radius: 4.0,
          ),
          title: Text(
            _itemName,
            textScaleFactor: 1.2,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    _details,
                    style: TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  new Icon(
                    Icons.timer,
                    size: 12.0,
                  ),
                  new Padding(
                    padding: EdgeInsets.only(right: 5.0),
                  ),
                  new Text(
                    _dueDate,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ],
          )),
    ));
  }
}

import 'package:meta/meta.dart' show required;
import 'package:quiver/core.dart';

class Class {
  int id;
  int classNo;
  int weekDay;
  DateTime startTime;
  DateTime endTime;
  String name;
  String location;
  String teacher;

  Class({
    @required this.classNo,
    @required this.startTime,
    @required this.endTime,
    @required this.name,
    this.weekDay, // a val of zero represents zero Recesses!
    this.location,
    this.teacher,
  });

  bool operator ==(Object classItem) =>
    identical(this, classItem) ||
      classItem is Class &&
        id == classItem.id &&
        classNo == classItem.classNo &&
        weekDay == classItem.weekDay &&
        startTime == classItem.startTime &&
        endTime == classItem.endTime &&
        name == classItem.name &&
        location == classItem.location &&
        teacher == classItem.teacher;

  int get hashCode =>
      hash4(id.hashCode, classNo.hashCode, weekDay.hashCode, name.hashCode);

  Class.fromMap(dynamic obj) {
    this.id = obj["id"];
    this.classNo = obj["classNo"];
    this.weekDay = obj["weekDay"];
    this.startTime = DateTime.parse(obj["startTime"]);
    this.endTime = DateTime.parse(obj["endTime"]);
    this.name = obj["name"];
    this.location = obj["location"];
    this.teacher = obj["teacher"];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = id;
    map["classNo"] = classNo;
    map["weekDay"] = weekDay;
    map["startTime"] = startTime.toString();
    map["endTime"] = endTime.toString();
    map["name"] = name;
    map["location"] = location;
    map["teacher"] = teacher;

    return map;
  }

  @override
  String toString(){
    String stringRepresentation =
        id.toString()
        + " " +  classNo.toString()
        + " " + weekDay.toString()
        + " " + startTime.toString()
        + " " + endTime.toString()
        + " " + name;

    return "$stringRepresentation";
  }

}
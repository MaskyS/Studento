import 'package:flutter/material.dart';
import '../UI/StudentoAppBar.dart';
import '../UI/StudentoDrawer.dart';
import '../UI/radial_menu/flutter_radial_menu.dart';
import  '../UI/TopicsListPage.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';


class TopicNotesPage extends StatefulWidget {
  static String routeName = "topic_notes_page";
  @override
  _TopicNotesPageState createState() => new _TopicNotesPageState();
}

class _TopicNotesPageState extends State<TopicNotesPage> {
  final List<String> listOfSubjects = ["General Paper AS", "French", "Mathematics", "Chemistry", "Physics", "Biology", "Economics", "Computer Science"];
  final String level = "A";
  GlobalKey<RadialMenuState> _menuKey = new GlobalKey<RadialMenuState>();

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new StudentoAppBar(),
      body: _buildRadialMenu(),
    );
  }

  RadialMenu _buildRadialMenu(){
    return new RadialMenu(
      key: _menuKey,
      items: _getRadialMenuItems(),
      radius: 125.0,
      onSelected: (selectedSubject){
        _menuKey.currentState.reset();
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => new SubjectTopicsListPage(selectedSubject[1], selectedSubject[0])),
        );
      }
    );
  }

  List<RadialMenuItem> _getRadialMenuItems() {
    List<RadialMenuItem> items = [];

    for (var index = 0; index < listOfSubjects.length; index++) {
      String subjectNameString = listOfSubjects[index];

      items.add(new RadialMenuItem(
        size: 70.0,
        value: [level, listOfSubjects[index]],
        tooltip: listOfSubjects[index],
        buttonText: subjectNameString,
      ));
    }
    return items;
  }

}


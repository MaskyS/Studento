import 'package:flutter/material.dart';
import '../UI/StudentoAppBar.dart';
import '../UI/StudentoDrawer.dart';
import '../UI/radial_menu/flutter_radial_menu.dart';


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
    //Contains the layout of the page.
    final page = new Scaffold(
      drawer: new StudentoDrawer(),
      appBar: new StudentoAppBar(),
      body: new Container(
        child: new Text('Hello!  This TopicNotesPage isn\'t ready for your eyes yet :)'),
      ),
    );

    return page;
  }
  RadialMenu _buildRadialMenu(){
    return new RadialMenu(
      key: _menuKey,
      items: _getRadialMenuItems(),
      radius: 125.0,
      onSelected: (selectedSubject){
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => new SubjectTopicsListPage(selectedSubject)),
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

class SubjectTopicsListPage extends StatelessWidget{
  final String selectedSubject;

  SubjectTopicsListPage(this.selectedSubject);

  @override
  Widget build(BuildContext) {
    return new Scaffold(
      appBar: new StudentoAppBar(),

    );
  }
}
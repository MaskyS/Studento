
import 'package:flutter/material.dart';
import '../UI/studento_app_bar.dart';
import '../UI/studento_drawer.dart';
import '../UI/subjects_staggered_grid_view.dart';


class SyllabusPage extends StatefulWidget{
  static String routeName = "syllabus_page";
  @override
  State<StatefulWidget> createState() {
    return new SyllabusPageState();
  }
}

class SyllabusPageState extends State<SyllabusPage>{

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      drawer: new StudentoDrawer(),
      body: new SubjectsStaggeredListView('syllabusPage'),
      appBar:new StudentoAppBar(
        title: new Text("Syllabus"),
      ),
    );
  }
}

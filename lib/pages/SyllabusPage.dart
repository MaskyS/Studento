// import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../UI/StudentoAppBar.dart';
import '../UI/StudentoDrawer.dart';
import '../UI/subjects_staggered_grid_view.dart';
// import 'package:shared_preferences/shared_preferences.dart';

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

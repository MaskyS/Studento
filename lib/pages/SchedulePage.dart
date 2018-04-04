import 'package:flutter/material.dart';
import '../UI/StudentoAppBar.dart';



class SchedulePage extends StatelessWidget {
  static String routeName = "schedule_page";

  Widget build(BuildContext context){

    //Contains the layout of the page.
    final page = new Scaffold(
      appBar: new StudentoAppBar().appBarMeta,
      body: new Container(
        child: new Text('Hello!  This SchedulePage isn\'t ready for your eyes yet :)'),
      ),
    );

    return page;
  }
}
import 'package:flutter/material.dart';
import '../UI/StudentoAppBar.dart';
import '../UI/StudentoDrawer.dart';

class TopicNotesPage extends StatelessWidget {
  static String routeName = "topic_notes_page";

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
}
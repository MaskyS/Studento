import 'package:flutter/material.dart';
import '../UI/studento_app_bar.dart';



class SchedulePage extends StatelessWidget {

  Widget build(BuildContext context){

    //Contains the layout of the page.
    final page = new Scaffold(
      appBar: new StudentoAppBar(),
      body: new Container(
        child: new Text('Hello!  This SchedulePage isn\'t ready for your eyes yet :)'),
      ),
    );

    return page;
  }
}
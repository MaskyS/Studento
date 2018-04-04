import 'package:flutter/material.dart';
import 'TimeTextWidget.dart';

class SliverStudentoAppBar extends StatelessWidget{
  Widget build(BuildContext context) {
    return new SliverAppBar(
      expandedHeight: 300.0,
      title: new Text("Studento",
        style: new TextStyle(
          fontFamily: 'Mina',
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),  
      ),
      centerTitle: true,
      backgroundColor: new Color(0xFF7c4dff),
      actions: <Widget>[
        new IconButton(
          icon: new Icon(Icons.notifications_active), /// TODO 1
          /// TODO 2
          color: Colors.white,
          onPressed: () {print("This will open up your schedule page! In the future anyway :P");},
        )
      ],
      flexibleSpace: new TimeTextWidget(),
      pinned: true,
    );
  }

  }
import 'package:flutter/material.dart';
import 'TimeTextWidget.dart';

/*
 * Holds the beauty that is the Studento SliverAppBar, which is exclusively
 * used in the Home Page.
 *
 * @returns SilverAppBar
 */
class SliverStudentoAppBar extends StatelessWidget{
  Widget build(BuildContext context) {
    return new SliverAppBar(
      expandedHeight: 290.0,
      title: new Text("Studento",
        style: new TextStyle(
          fontFamily: 'Mina',
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.deepPurpleAccent,
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
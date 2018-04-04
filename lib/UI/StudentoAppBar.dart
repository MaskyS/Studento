import 'package:flutter/material.dart';
/* This variable contains all the needed configurations for the app bar
  * When we need to use the app bar in  a certain page:
  * - import this class.
  * In your Scaffold widget, use the following key-value pair:
  *   appBar: new StudentoAppBar().appBarMeta,
  * That's it!
  * I used the appBarMeta variable because returning the configuration as
  * Widget didn't work.
  * If you have found a better way, please post it on
  * https://github.com/MaskyS/studento/issues :)
  */

class StudentoAppBar {
  final appBarMeta = new AppBar(
    title: new Text('Studento',
      style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Mina',
          fontWeight: FontWeight.w700,
          fontSize: 30.0,
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
  );
}

///TODO 1: 
/// Implement dynamic icon setup, i.e. The icon should change depending on how
/// close the deadline is.

///TODO 2 :
/// Change the icon's color depending on state. i.e. how close
/// the next deadline is, or if user has any homework left.
/// Something like: color: (__isDeadlineApproaching) ? red : green 
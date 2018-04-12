import 'package:flutter/material.dart';

/// Contains the custom Studento AppBar.

class StudentoAppBar extends AppBar{
  StudentoAppBar({Key key,
  Widget title: const Text("Studento",
    style: const TextStyle(
      color: Colors.white,
      fontFamily: 'Mina',
      fontWeight: FontWeight.w700,
      fontSize: 26.0,
    ),),
     List<Widget> actions})

  : super(key: key,
    title: title,
    actions: actions,
    centerTitle: true,
    backgroundColor: Colors.deepPurpleAccent
  );

}
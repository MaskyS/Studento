import 'package:flutter/material.dart';

/// Contains the custom Studento AppBar.

class StudentoAppBar extends AppBar {
  StudentoAppBar(
    {Key key,
    String title: "Studento",
    TextStyle titleStyle : const TextStyle(color: Colors.white),
    PreferredSizeWidget bottom,
    List<Widget> actions}
  ): super(
    key: key,
    title: Text(title, style: titleStyle),
    actions: actions,
    centerTitle: true,
    backgroundColor: Colors.deepPurpleAccent,
    bottom: bottom
  );
}

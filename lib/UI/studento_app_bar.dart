import 'package:flutter/material.dart';

/// Contains the custom Studento AppBar.

class StudentoAppBar extends AppBar {
  StudentoAppBar(
    {Key key,
    String title: "Studento",
    TextStyle titleStyle : const TextStyle(color: Colors.black87),
    PreferredSizeWidget bottom,
    IconThemeData iconTheme: const IconThemeData(color: Colors.black87),
    List<Widget> actions}
  ): super(
    key: key,
    title: Text(title, style: titleStyle, textScaleFactor: 1.2,),
    actions: actions,
    centerTitle: true,
    backgroundColor: Colors.white,
    bottom: bottom
  );
}

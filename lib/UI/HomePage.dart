import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../UI/HomePageBody.dart';
import '../UI/StudentoAppBar.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return new Scaffold(
      body: new Column(
        children: <Widget>[
           new StudentoAppBar("Studento"),
          new HomePageBody(),
        ],
      )
    );
  }
}
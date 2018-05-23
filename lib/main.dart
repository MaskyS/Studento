import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'util/shared_prefs_interface.dart';
import 'pages/setup.dart';

import 'routes.dart';

void main() => runApp(Studento());

  class Studento extends StatefulWidget {
    @override
    _StudentoState createState() => _StudentoState();
  }

  class _StudentoState extends State<Studento> {
    bool hasRunBefore;

    void isRunBefore() async{
      hasRunBefore = await SharedPreferencesHelper.getIsFirstRun();
      if (hasRunBefore != true) hasRunBefore = false;
    }
    @override
      void initState() {
        isRunBefore();
        // TODO: implement initState
        super.initState();
      }
  @override
  Widget build(BuildContext context) {
    // Hide the status bar. We don't want students to be distracted by
    // notifications.
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.values[1]]);

    // Lock app orientation to Portrait so rotating doesn't break the design.
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return MaterialApp(
      title: 'Studento',
      home: (hasRunBefore == true) ? routes[homeRoute] : Setup(),
      routes: routes,
      theme: ThemeData(fontFamily: 'Montserrat'),
    );
  }
}

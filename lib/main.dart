import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'routes.dart';

void main() => runApp(new Studento());

class Studento extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Hide the status bar. We don't want students to be distracted by
    // notifications.
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.values[1]]);

    // Lock app orientation to Portrait so rotating doesn't break the design.
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return new MaterialApp(
      title: 'Studento',
      routes: routes,
      theme: new ThemeData(fontFamily: 'Montserrat'),
    );
  }
}

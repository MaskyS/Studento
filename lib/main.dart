import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'util/shared_prefs_interface.dart';
import 'UI/loading_page.dart';

import 'routes.dart';
import 'pages/home_page.dart';
import 'pages/intro.dart';

void main() => runApp(Studento());

  class Studento extends StatefulWidget {
    @override
    _StudentoState createState() => _StudentoState();
  }

class _StudentoState extends State<Studento> {
  bool isSetupComplete;

  void checkifSetupComplete() async{
    bool _isSetupComplete = await SharedPreferencesHelper.getIsFirstRun() ?? false;
    setState(() => isSetupComplete = _isSetupComplete);
    print("Has run before is $isSetupComplete");
  }

  @override
  void initState() {
    checkifSetupComplete();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isSetupComplete == null) return loadingPage();

    // Lock app orientation to Portrait so rotating doesn't break the design.
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return MaterialApp(
      title: 'Studento',
      home: (isSetupComplete) ? HomePage() : IntroPage(),
      routes: routes,
      theme: ThemeData(
        fontFamily: 'Montserrat',
        // Studento Blue
        primaryColor: Colors.deepPurpleAccent,
        accentColor: Colors.blue,
        primaryIconTheme: IconThemeData(color: Colors.black87),
        // Studento Pink
        buttonColor: Colors.blue,
      ),
    );
  }
}

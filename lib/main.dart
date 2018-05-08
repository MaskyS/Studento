import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/HomePage.dart';
import 'pages/PastPapersPage.dart';
import 'pages/SyllabusPage.dart';
import 'pages/EventsPage.dart';
import 'pages/MarksCalculatorPage.dart';
import 'pages/GetProPage.dart';
import 'pages/SettingsPage.dart';
import 'pages/SchedulePage.dart';
import 'pages/TodoListPage.dart';
import 'pages/topic_notes.dart';

void main() => runApp(new Studento());

class Studento extends StatelessWidget {

  final routes = <String, WidgetBuilder> {
  HomePage.routeName : (BuildContext context) => new HomePage(),
  PastPapersPage.routeName : (BuildContext context) => new PastPapersPage(),
  SchedulePage.routeName : (BuildContext context) => new SchedulePage(),
  SyllabusPage.routeName : (BuildContext context) => new SyllabusPage(),
  EventsPage.routeName : (BuildContext context) => new EventsPage(),
  MarksCalculatorPage.routeName : (BuildContext context) => new MarksCalculatorPage(),
  GetProPage.routeName : (BuildContext context) => new GetProPage(),
  SettingsPage.routeName : (BuildContext context) => new SettingsPage(),
  TodoListPage.routeName : (BuildContext context) => new TodoListPage(),
  TopicNotesPage.routeName : (BuildContext context) => new TopicNotesPage(),
  };

  @override
  Widget build(BuildContext context) {
    // Hide the status bar. We don't want students to be distracted by
    // notifications.
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.values[1]]);

    // Lock app orientation to Portrait so rotating doesn't break the design.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);

    return new MaterialApp(
	    title: 'Studento',
	    home: new HomePage(),
      routes: routes,
      theme: new ThemeData(
        fontFamily: 'Montserrat'
      ),
    );
  }

}
import 'package:flutter/material.dart';
import './pages/HomePage.dart';
import 'pages/PastPapersPage.dart';
import 'pages/SyllabusPage.dart';
import 'pages/EventsPage.dart';
import 'pages/MarksCalculatorPage.dart';
import 'pages/GetProPage.dart';
import 'pages/SettingsPage.dart';
import 'pages/SendFeedbackPage.dart';

void main() => runApp(new Studento());

class Studento extends StatelessWidget {

  var routes = <String, WidgetBuilder> {
  HomePage.routeName : (BuildContext context) => new HomePage(),
  PastPapersPage.routeName : (BuildContext context) => new PastPapersPage(),
  SyllabusPage.routeName : (BuildContext context) => new SyllabusPage(),
  EventsPage.routeName : (BuildContext context) => new EventsPage(),
  MarksCalculatorPage.routeName : (BuildContext context) => new MarksCalculatorPage(),
  GetProPage.routeName : (BuildContext context) => new GetProPage(),
  SettingsPage.routeName : (BuildContext context) => new SettingsPage(),
  SendFeedbackPage.routeName : (BuildContext context) => new SendFeedbackPage()

  };

  @override
  Widget build(BuildContext context) {
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
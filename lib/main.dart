import 'package:flutter/material.dart';
import './pages/HomePage.dart';

void main() => runApp(new StudentoApp());

class StudentoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
	    title: 'Studento',
	    home: new HomePage(),
      // Set Montserrat as the default app font
      theme: new ThemeData(fontFamily: 'Montserrat'),
    );
  }
	
}
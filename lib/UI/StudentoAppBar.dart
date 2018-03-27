import 'package:flutter/material.dart';

class StudentoAppBar extends StatelessWidget {

  final String title;
  final double barHeight = 66.0;

  StudentoAppBar(this.title);

  @override
  Widget build(BuildContext context) {

    return new Container(
      height: barHeight,
      decoration: new BoxDecoration(
        color: new Color(0xFF5fbff9)
    ),
      child: new Center(
        child: new Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Mina',
            fontWeight: FontWeight.bold,
            fontSize: 36.0,
          ),
        ),
      ),
    );
  }
}
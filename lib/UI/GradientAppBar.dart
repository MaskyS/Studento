import 'package:flutter/material.dart';

class GradientAppBar  extends StatelessWidget {

  final String title;
  final double barHeight = 66.0;

  GradientAppBar(this.title);

  @override
  Widget build(BuildContext context) {

    return new Container(
      height: barHeight,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [
            const Color(0xFF396afc),
            const Color(0xFF2948ff),
          ],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp
      ),
    ),
      child: new Center(
        child: new Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Berkshire Swash',
            fontWeight: FontWeight.normal,
            fontSize: 36.0,
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class ButtonRow extends StatelessWidget {
   @override
  Widget build(BuildContext context) {
    final buttonIcon = new Container(
      margin: new EdgeInsets.symmetric(
        vertical: 16.0
      ),
      alignment: FractionalOffset.centerLeft,
      child: new Image(
        image: new AssetImage("assets/icons/exam.svg"),
        height: 92.0,
        width: 92.0,
      ),
    );

    final buttonCard = new Container(
      height: 60.0,
      width: 140.0,
      margin: new EdgeInsets.only(left: 20.0, top: 20.0),
      decoration: new BoxDecoration(
        color: new Color(0xFFEAE9E9),
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(18.0),
        border: new Border.all(color: new Color( 0xFF037BB5), width: 3.0,),

      ),
    child: new Container(
      padding: const EdgeInsets.only(top: 18.5),
        child: new Text(
          "Exam Papers",
          style: new TextStyle(
            fontFamily: 'Big John',
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
            color: new Color(0xFF5E5454),
          ),
          textAlign: TextAlign.center,
        )
     )

    );

     return new Container(
       margin: const EdgeInsets.symmetric(
         vertical: 16.0,
         horizontal: 24.0,
      ),
      child: new Stack(
        children: <Widget>[
          buttonCard,
          buttonIcon,
        ],
      ),
    );
  } // Widget>
}
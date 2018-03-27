//  TODO Fix alignment
import 'package:flutter/material.dart';

class HomePageButton extends StatelessWidget{

  final String title;
  final String iconFilePath;
  final double marginTop;
  final double marginRight;
  final double marginLeft;
  final double iconMarginTop;
  bool isAlignedRight;

  HomePageButton(this.title, this.isAlignedRight, this.iconFilePath, this.marginTop, this.iconMarginTop, {this.marginRight, this.marginLeft});

  @override
  Widget build (BuildContext context){
    final buttonIcon = new Container(
      margin: new EdgeInsets.symmetric(
        vertical: iconMarginTop,
      ),
      alignment: (isAlignedRight) 
        ? FractionalOffset.centerRight  
        : FractionalOffset.centerLeft,
      child: new Image(
        image: new AssetImage("assets/icons/" + iconFilePath),
        height: 90.0,
        width: 100.0,
      ),
    );

    final buttonCard = new Container(
      height: 60.0,
      width: 165.0,
      alignment: (isAlignedRight) 
        ? FractionalOffset.centerRight
        : FractionalOffset.centerLeft,
      margin: (isAlignedRight) 
        ? new EdgeInsets.only(left: marginLeft, top: marginTop)
        : new EdgeInsets.only(left: marginLeft, top: marginTop),
      decoration: new BoxDecoration(
        color: new Color(0xEE6537FF),
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(5.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          )
        ]
      ),

      child: new Container(
        alignment: (isAlignedRight) ?  Alignment.center : Alignment.center,
        padding: const EdgeInsets.only(left: 0.0, top: 0.0),
        child: new Text(
          title,
          textAlign: TextAlign.center,
          style: new TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

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
  }
}

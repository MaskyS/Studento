import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../UI/StudentoDrawer.dart';
import '../UI/SliverStudentoAppBar.dart';

class HomePage extends StatelessWidget{
  static String routeName = "home_page";
  Widget build(BuildContext context){
    // Hide status bar and nav bar
    SystemChrome.setEnabledSystemUIOverlays([]);

    // Contents of page
    return new Scaffold( 
      drawer: new StudentoDrawer(),
      body: new CustomScrollView(
        slivers: <Widget>[
          new SliverStudentoAppBar(),
              new SliverGrid(
      gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200.0,
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
        childAspectRatio: 1.0,
      ),
      delegate: new SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return new Container(
            alignment: Alignment.center,
            color: Colors.blue[200 * (index)],
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[ new Icon(Icons.list), new Text("TEXT $index",
                style: new TextStyle(
                  color: new Color(0xFF1a1a1a),
                  fontWeight: FontWeight.w700,
                ),
              )
            ]), 
          );
        },
        childCount: 4,
      ),
    ),
        ],
      )
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../UI/StudentoDrawer.dart';
import '../UI/StudentoAppBar.dart';
import '../UI/HomePageBody.dart';

import '../pages/PastPapersPage.dart';


class HomePage extends StatelessWidget{
  static String routeName = "home_page";
  Widget build(BuildContext context){
    // Hide status bar and nav bar
    SystemChrome.setEnabledSystemUIOverlays([]);

    // Contents of page
    return new Scaffold( 
      drawer: new StudentoDrawer(),
      body: new GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new PastPapersPage()),
          );
        },
        child: new HomePageBody(),
      ),
      appBar: new StudentoAppBar().appBarMeta,
      );
  }
}
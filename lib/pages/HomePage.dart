import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../UI/StudentoDrawer.dart';
import '../UI/HomePageBody.dart';



class HomePage extends StatelessWidget{

  static String routeName = "home_page";
  Widget build(BuildContext context){
    // Hide the status bar. We don't want students to be distracted by
    // notifications.
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.values[1]]);

    return new Scaffold(
      drawer: new StudentoDrawer(usedInHomePage : true),
      // Since this page has a SliverAppBar, we cannot use the appBar property
      // here, so the appBar is placed inside the body instead.
      body: new HomePageBody(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../UI/StudentoDrawer.dart';
import '../UI/StudentoAppBar.dart';
import '../UI/HomePageBody.dart';


class HomePage extends StatelessWidget{
  Widget build(BuildContext context){
    // Lock orientation to Portait mode.
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // Hide status bar and nav bar
    SystemChrome.setEnabledSystemUIOverlays([]);

    // Contents of page
    return new Scaffold( 
      drawer: new StudentoDrawer(),
      body: new HomePageBody(),
      appBar: new StudentoAppBar().appBarMeta,
    );
  }
}
import 'package:flutter/material.dart';
import '../UI/StudentoAppBar.dart';

class SendFeedbackPage extends StatelessWidget {
  static String routeName = "send_feedback_page";

  Widget build(BuildContext context){

    //Contains the layout of the page.
    final page = new Scaffold(
      appBar: new StudentoAppBar(),
      body: new Container(
        child: new Text('Hello!  This SendFeedbackPage isn\'t ready for your eyes yet :)'),
      ),
    );

    return page;
  }
}
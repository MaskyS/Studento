import 'package:flutter/material.dart';
import '../UI/HomePageButton.dart';

class HomePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Args: Button Title, isAlignedRight, file_icon_path, marginTop of card, margin_top of icon, margin_left of card.
    final button1 = new HomePageButton("PAST PAPERS", false, 'exam_icon.png', 51.0, 28.0, marginLeft: 64.0);
    final button2 = new HomePageButton("SCHEDULE", true, 'schedule_icon.png', 178.0, 163.0, marginLeft: 130.0);
    final button3 = new HomePageButton("TODO LIST", false, 'todo-list_icon.png', 303.0, 279.5, marginLeft: 64.0);
    final button4 = new HomePageButton("TOPIC NOTES", true, 'notes_icon.png', 428.0, 403.0, marginLeft: 130.0);
    return new Container( 
      child: new Stack(
        children: <Widget>[
          button1,
          button2,
          button3,
          button4,

        ],
      ),
    );

  }
}
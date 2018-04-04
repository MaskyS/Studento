import 'package:flutter/material.dart';
import 'package:studentapp/pages/SchedulePage.dart';
import 'package:studentapp/pages/PastPapersPage.dart';
import '../pages/TodoListPage.dart';
import 'package:studentapp/pages/TopicNotesPage.dart';
import 'package:studentapp/UI/TimeTextWidget.dart';
/*
 * The alignment/layout in this class isn't done right yet. Currently this
 * looks good on a GPixel 2, but ir probably doesn't elsewhere. I need to look
 * into the Rows and Columns system to see if that can work. Otherwise, very
 * much work in progress here concerning the layout.
 */

class HomePageBody extends StatelessWidget{


  Widget build(BuildContext context){

    final _homePageButtonsRow1 = new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new HomePageButton("PAST PAPERS", 'exam_icon.png'),
        new HomePageButton("SCHEDULE", 'schedule_icon.png'),
      ],
    ); 
    final _homePageButtonsRow2 = new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new HomePageButton("TODO LIST", 'todo-list_icon.png'),
        new HomePageButton("TOPIC NOTES", 'notes_icon.png'),
      ],
    );


    return new ListView(children: <Widget>[
      new TimeTextWidget(),
      _homePageButtonsRow1,
      _homePageButtonsRow2
    ]);
  }

} // HomePageBody

class HomePageButton extends StatelessWidget{

  final String title;
  final String iconFilePath;

  HomePageButton(this.title, this.iconFilePath);

  @override
  Widget build (BuildContext context){

    final _buttonIcon = new Container(
      margin: new EdgeInsets.only(bottom: 10.0),
      child: new Image(image: new AssetImage("assets/icons/" + iconFilePath)),
      constraints: new BoxConstraints.loose(new Size(50.0, 50.0)),
      );

    final _buttonCard = new Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 0.0, top: 0.0),
        child: new Text(
          title,
          textAlign: TextAlign.center,
          style: new TextStyle(
            fontSize: 10.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
    );


    return new GestureDetector(
      onTap:  () {
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) =>
          /// Ugly code but this is the best I could come with, since I
          /// can't use if/switch statements. The ternary operators will assign
          ///  the correct route by  checking the title passed to the
          /// HomePageButton() constructor.
          (title == "PAST PAPERS") ? new PastPapersPage() 
            :(title == "SCHEDULE") ? new SchedulePage()
            : (title == "TODO LIST") ? new TodoListPage() 
            : (title == "TOPIC NOTES") ? new TopicNotesPage() : new Error()
        ),
        );

},

      child: new Container(
        width: 80.0,
        child: new Column(children: <Widget>[_buttonIcon, _buttonCard]),
      ),
    );
  }
}


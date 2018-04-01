import 'package:flutter/material.dart';
import '../pages/PastPapersPage.dart';
import '../pages/SchedulePage.dart';
import '../pages/TodoListPage.dart';
import '../pages/TopicNotesPage.dart';

class HomePageBody extends StatelessWidget{
  Widget build(BuildContext context){
    //Args: Button Title, isAlignedRight, isAlignedTop, icon_file_path, marginVertical of card, margin_top of icon, marginHorizontal of card.
    final pastPapersButton = new HomePageButton("PAST PAPERS", false, true, 'exam_icon.png', 68.0, 40.0, marginHorizontal: 64.0);
    final scheduleButton = new HomePageButton("SCHEDULE", true, true,'schedule_icon.png', 210.0, 192.0, marginHorizontal: 135.0);
    final todoListButton = new HomePageButton("TODO LIST", false, false,'todo-list_icon.png', 350.0, 146.0, marginHorizontal: 64.0);
    final topicNotesButton = new HomePageButton("TOPIC NOTES", true, false,'notes_icon.png', 490.0, 5.0, marginHorizontal: 135.0);
    return new Container( 
      child: new Stack(
        children: <Widget>[
          pastPapersButton,
          scheduleButton,
          todoListButton,
          topicNotesButton,
        ],
      ),
    );
  }

} // HomePageBody

class HomePageButton extends StatelessWidget{

  final String title;
  final String iconFilePath;
  final double marginVertical;
  final double marginHorizontal;
  final double iconmarginVertical;
  final bool isAlignedRight;
  final bool isAlignedTop;
  

  HomePageButton(this.title, this.isAlignedRight, this.isAlignedTop, this.iconFilePath, this.marginVertical, this.iconmarginVertical, {this.marginHorizontal});
  @override
  Widget build (BuildContext context){

    final buttonIcon = new Container(
      alignment: (isAlignedRight) 
      ? isAlignedTop 
        ? FractionalOffset.topRight
        : FractionalOffset.bottomRight
      : isAlignedTop 
        ? FractionalOffset.topLeft
        : FractionalOffset.bottomLeft,
        
      margin: (isAlignedTop) 
        ? new EdgeInsets.only(top: iconmarginVertical)
        : new EdgeInsets.only(bottom: iconmarginVertical),
      child: new Image(
        image: new AssetImage("assets/icons/" + iconFilePath),
        width: 90.0,
        height: 100.0,
      ),
    );

    final buttonCard = new Container(
      height: 60.0,
      width: 165.0,
      alignment: (isAlignedRight) 
        ? FractionalOffset.centerRight
        : FractionalOffset.centerLeft,
      margin: (isAlignedRight) 
        ? new EdgeInsets.only(left: marginHorizontal, top: marginVertical)
        : new EdgeInsets.only(left: marginHorizontal, top: marginVertical),
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
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 0.0, top: 0.0),
        child: new Text(
          title,
          textAlign: TextAlign.center,
          style: new TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

    );
    return new GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) =>
          /// Very ugly code but this is the best I could come with, since I
          /// can't use if/switch statements. The ternary operators will assign
          ///  the correct route by  checking the title passed to the
          /// HomePageButton() constructor.
          (title == "PAST PAPERS") ?
            new PastPapersPage() 
          :(title == "SCHEDULE") ?
            new SchedulePage()
            : (title == "TODO LIST") ?
              new TodoListPage() : 
              (title == "TOPIC NOTES") ?
                new TopicNotesPage() : new Error()
        ),
        );

      },
      child: new Container(
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
      )
    );
  }

}

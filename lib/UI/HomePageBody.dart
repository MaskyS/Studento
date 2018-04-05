import 'package:flutter/material.dart';
import '../pages/SchedulePage.dart';
import '../pages/PastPapersPage.dart';
import '../pages/TodoListPage.dart';
import '../pages/TopicNotesPage.dart';
import '../UI/SliverStudentoAppBar.dart';

/// The UI for the IconButtons and the text below them.
///
/// @returns Container
class HomePageButton extends StatelessWidget {
  final String _title;
  final String _iconFilePath;

  HomePageButton(this._title, this._iconFilePath);

  @override
  Widget build (BuildContext context) {
    final Container _buttonIcon = new Container(
      margin: new EdgeInsets.only(bottom: 10.0),
      child: new Image(image: new AssetImage("assets/icons/" + _iconFilePath)),
      constraints: new BoxConstraints.loose(new Size(45.0, 45.0)),
      );

    final Container _buttonText = new Container(
        alignment: Alignment.center,
        child: new Text(
          _title,
          textAlign: TextAlign.center,
          style: new TextStyle(
            fontSize:13.5,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
    );


    return new Container(
        width: 100.0,
        child: new Column(children: <Widget>[_buttonIcon, _buttonText]),
    );
  }

}

/// This class holds the layout and the routing config for the Home Page.
/// The SliverGrid part might look like confusing spaghetti code, so I recommend
/// looking at https://goo.gl/tSV2ps.
class HomePageBody extends StatelessWidget{
  Widget build(BuildContext context){
    List _iconButtonList = [
      new HomePageButton('PAST PAPERS', 'exam_icon.png'),
      new HomePageButton("SCHEDULE", 'schedule_icon.png'),
      new HomePageButton("TODO LIST", 'todo-list_icon.png'),
      new HomePageButton("TOPIC NOTES", 'notes_icon.png'),
    ];
    return new CustomScrollView(
        slivers: <Widget>[
          new SliverStudentoAppBar(),
          new SliverGrid(
            gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 1.0,
              childAspectRatio: 1.2,
            ),

            delegate: new SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return new GestureDetector(
                  onTap:  () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(builder: (context) =>
                      /// Ugly code but this is the best I could come with,
                      /// since I can't use if/switch statements. The ternary
                      /// operators will assign the correct route by checking
                      /// the index of the _iconButtonList[]. In english, I mean
                      ///  that we check which button was pressed and hence
                      /// provide the appropriate page.
                      (index == 0) ? new PastPapersPage()
                        :(index == 1) ? new SchedulePage()
                        : (index == 2) ? new TodoListPage()
                        : (index == 3) ? new TopicNotesPage() : new Error()
                      ),
                    );
                  },

                  child: new Container(
                    decoration: new BoxDecoration(
                      border: new Border(
                        bottom: (index < 2) ? new BorderSide(color: Colors.blue[700]) : BorderSide.none,
                        right: new BorderSide(color: Colors.blue[700]),
                      ),
                    ),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // Here we place the Icon and text widgets.
                      children: <Widget>[_iconButtonList[index]],
                    ),
                  ),
                );
              },
            childCount: 4,
          ),
        ),
      ],
    );
  }
} // HomePageBody




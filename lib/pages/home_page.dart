import 'package:flutter/material.dart';

import '../UI/studento_drawer.dart';
import '../UI/sliver_studento_app_bar.dart';

class HomePage extends StatelessWidget {
  final List _iconButtonList = [
    new HomePageButton('PAST PAPERS', 'exam_icon.png'),
    new HomePageButton("SCHEDULE", 'schedule_icon.png'),
    new HomePageButton("TODO LIST", 'todo-list_icon.png'),
    new HomePageButton("TOPIC NOTES", 'notes_icon.png'),
  ];

  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new StudentoDrawer(usedInHomePage: true),
      // Since this page has a SliverAppBar, we cannot use the appBar property
      // here, so the appBar is placed inside the body instead.
      body: _buildTopicListView(context),
    );
  }

  /// Takes [iconsButtonListIndex], figures out which button was pressed then
  /// returns the appropriate page's [routeName].
  String _getPageToBePushed(int iconsButtonListIndex) {
    switch (iconsButtonListIndex) {
      case 0:
        return 'past_papers_page';
        break;

      case 1:
        return 'schedule_page';
        break;

      case 2:
        return 'todo_list_page';
        break;

      default:
        return 'topic_notes_page';
    }
  }

  Widget _buildTopicListView(BuildContext context) {
    return new CustomScrollView(
      slivers: <Widget>[
        new SliverStudentoAppBar(),
        new SliverGrid(
          gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            crossAxisSpacing: 1.0,
            childAspectRatio: 1.2,
          ),
          delegate: new SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return new GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, _getPageToBePushed(index));
                },
                child: new Container(
                  decoration: new BoxDecoration(
                    border: new Border(
                      bottom: (index < 2)
                          ? new BorderSide(color: Colors.blue[700])
                          : BorderSide.none,
                      right: (index == 0 || index == 2)
                          ? new BorderSide(color: Colors.blue[700])
                          : BorderSide.none,
                    ),
                  ),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
}

/// The UI for the IconButtons on the HomePage and the text below them.
class HomePageButton extends StatelessWidget {
  final String _title;
  final String _iconFilePath;

  HomePageButton(this._title, this._iconFilePath);

  @override
  Widget build(BuildContext context) {
    Widget _buttonIcon = new Container(
      margin: new EdgeInsets.only(bottom: 10.0),
      child: new Image(image: new AssetImage("assets/icons/" + _iconFilePath)),
      constraints: new BoxConstraints.loose(new Size(45.0, 45.0)),
    );

    Widget _buttonText = new Container(
      alignment: Alignment.center,
      child: new Text(
        _title,
        textAlign: TextAlign.center,
        style: new TextStyle(
          fontSize: 13.5,
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
} // Hom

import 'package:flutter/material.dart';
import 'package:meta/meta.dart' show required;

import '../UI/studento_drawer.dart';
import '../UI/sliver_studento_app_bar.dart';

class HomePage extends StatelessWidget {
  final List<HomePageButton> _iconButtonList = [
    HomePageButton(
      title: 'PAST PAPERS',
      iconFilePath: 'exam_icon.png',
    ),
    HomePageButton(
      title: "SCHEDULE",
      iconFilePath: 'schedule_icon.png',
    ),
    HomePageButton(
      title: "TODO LIST",
      iconFilePath: 'todo-list_icon.png',
    ),
    HomePageButton(
      title: "TOPIC NOTES",
      iconFilePath: 'notes_icon.png',
    ),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: StudentoDrawer(usedInHomePage: true),
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
    return CustomScrollView(
      slivers: <Widget>[
        SliverStudentoAppBar(),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            crossAxisSpacing: 1.0,
            childAspectRatio: 1.2,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return GestureDetector(
                onTap: () =>
                  Navigator.pushNamed(context, _getPageToBePushed(index)),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: (index < 2)
                          ? BorderSide(color: Colors.blue[700])
                          : BorderSide.none,
                      right: (index == 0 || index == 2)
                          ? BorderSide(color: Colors.blue[700])
                          : BorderSide.none,
                    ),
                  ),
                  child: Column(
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
  final String title;
  final String iconFilePath;

  HomePageButton({@required this.title, @required this.iconFilePath});

  @override
  Widget build(BuildContext context) {
    Widget _buttonIcon = Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: Image(image: AssetImage("assets/icons/$iconFilePath")),
      constraints: BoxConstraints.loose(Size(45.0, 45.0)),
    );

    Widget _buttonText = Container(
      alignment: Alignment.center,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );

    return Container(
      width: 100.0,
      child: Column(children: <Widget>[_buttonIcon, _buttonText]),
    );
  }
} // Hom

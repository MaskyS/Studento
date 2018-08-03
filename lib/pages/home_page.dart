import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

import '../UI/studento_app_bar.dart';
import '../UI/studento_drawer.dart';
import '../UI/clock.dart';
import '../UI/vertical_divider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Widget buildButtonRow({
      @required Widget button1,
      @required Widget button2
    }) => Expanded(
      flex: 1,
      child: Row(
        children: <Widget>[
          button1,
          VerticalDivider(
            color: Colors.blue,
            width: 3.0,
          ),
          button2,
        ],
      ),
  );

  @override
  Widget build(BuildContext context) {

    List<Widget> appBarActions = <Widget>[
      IconButton(
        icon: Icon(Icons.notifications_active),
        onPressed: () =>
          print(
              "This will open up your schedule page! In the future anyway :P"),
      ),
    ];

    TextStyle appBarTitleStyle  = TextStyle(
      color: Colors.black,
      fontFamily: 'Montserrat',
      fontSize: 26.0,
      fontWeight: FontWeight.w400,
    );

    PreferredSizeWidget appBar = StudentoAppBar(
      title: "STUDENTO",
      actions: appBarActions,
      titleStyle: appBarTitleStyle,
    );

    Widget clockContainer() => Expanded(
      flex: 2,
      child: Container(
        alignment: Alignment.center,
        constraints: BoxConstraints.expand(),
        color: Colors.deepPurpleAccent,
        child: Clock(),
      ),
    );

    Widget pastPapersButton = HomePageButton(
      label: "PAST PAPERS",
      iconFileName: "exam_icon.png",
      routeToBePushedWhenTapped: 'past_papers_page',
    );

    Widget scheduleButton = HomePageButton(
      label: "SCHEDULE",
      iconFileName: "schedule_icon.png",
      routeToBePushedWhenTapped: 'schedule_page',
    );

    Widget todoListButton = HomePageButton(
      label: "TODO LIST",
      iconFileName: "todo-list_icon.png",
      routeToBePushedWhenTapped: 'todo_list_page',
    );

    Widget topicNotesButton = HomePageButton(
      label: "TOPIC NOTES",
      iconFileName: "notes_icon.png",
      routeToBePushedWhenTapped: 'topic_notes_page',
    );

    Widget buttonRow1 = buildButtonRow(
      button1: pastPapersButton,
      button2: scheduleButton
    );

    Widget buttonRow2 = buildButtonRow(
      button1: todoListButton,
      button2: topicNotesButton
    );

    return Scaffold(
      appBar: appBar,
      drawer: StudentoDrawer(),
      body:Column(
        children: <Widget>[
          clockContainer(),
          buttonRow1,
          Divider(height: 3.0, color: Colors.blue,),
          buttonRow2,
        ],
      ),
    );
  }
}

class HomePageButton extends StatelessWidget {

  HomePageButton({
    @required this.label,
    @required this.iconFileName,
    @required this.routeToBePushedWhenTapped,
  });

  final String label;

  final String iconFileName;

  final String routeToBePushedWhenTapped;

  void pushRoute(BuildContext context){
     Navigator.of(context).pushNamed(routeToBePushedWhenTapped);
  }

  Widget icon() => Expanded(
    flex: 1,
    child: Image(
      fit: BoxFit.contain,
      image: AssetImage("assets/icons/$iconFileName"),
    ),
  );

  final TextStyle labelStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  Widget labelText() => Expanded(flex:1, child: Text(
    label,
    textScaleFactor: 1.2,
    style: labelStyle,
  ));

  @override
  Widget build(BuildContext context) {

    buttonsContainer() => Container(
      alignment: Alignment.center,
      color: Colors.white70,
      constraints: BoxConstraints.expand(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(padding: EdgeInsets.all(20.0)),
          icon(),
          Padding(padding: EdgeInsets.all(5.0)),
          labelText(),
        ],
      ),
    );

    return Expanded(
      child: Tooltip(
      verticalOffset: 5.0,
      message: label,
        child: InkWell(
          onTap: () => pushRoute(context),
          child: buttonsContainer(),
        ),
      ),
    );
  }
}
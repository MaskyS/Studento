import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class TopicSelectPage extends StatefulWidget {
  final String selectedSubject;
  final String level;
  TopicSelectPage(this.selectedSubject, this.level);

  @override
  _TopicSelectPageState createState() =>
      new _TopicSelectPageState(selectedSubject, level);
}

class _TopicSelectPageState extends State<TopicSelectPage> {
  List topicsList;
  String selectedSubject;
  final String level;
  _TopicSelectPageState(this.selectedSubject, this.level);

  @override
  void initState() {
    super.initState();
    getTopicsList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        constraints: new BoxConstraints.expand(),
        child: new Stack(children: <Widget>[
          _getTopicsListView(),
          _getBackground(),
          _getGradient(),
          _getToolbar(context),
        ]),
      ),
    );
  }

  void getTopicsList() async {
    var _topicsList;
    String _topicsListData =
        await rootBundle.loadString('assets/json/subjects_topic_lists.json');
    Map topicsListData = json.decode(_topicsListData);

    try {
      _topicsList =
          topicsListData[selectedSubject]['topic_list']['$level level'];
    } catch (e) {
      showNotesNotFoundDialog();
    }
    setState(() {
      topicsList = _topicsList;
    });
  }

  Widget _getBackground() {
    final Widget subjectNameAndNoOfTopicsContainer = new Container(
      constraints: new BoxConstraints.expand(height: 250.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: (topicsList == null)
            ? <Widget>[new CircularProgressIndicator()]
            : <Widget>[
                new Text(
                  "$selectedSubject",
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontFamily: 'Mina',
                    color: Colors.white,
                    fontSize: 30.0,
                  ),
                ),
                new Padding(
                    padding: const EdgeInsets.only(
                  bottom: 4.0,
                )),
                new Text(
                  "${topicsList.length} topics",
                  style: new TextStyle(
                    color: new Color(0xFFFefefe),
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
      ),
    );

    // TODO Turn this into a SliverAppBar for better mobility.
    // Also, instead of the background image let's get some fancy animation
    // like https://www.youtube.com/watch?v=MAET-z1apKA on a dark purple
    // background or the like.
    return new Stack(
      children: <Widget>[
        new Container(
          constraints: new BoxConstraints.expand(height: 250.0),
          child: new Image.asset(
            "assets/images/physics-background-img.jpg", //subject.picture,
            fit: BoxFit.cover,
            height: 300.0,
          ),
        ),
        subjectNameAndNoOfTopicsContainer,
      ],
    );
  }

  Widget _getGradient() {
    return new Container(
      height: 90.0,
      margin: new EdgeInsets.only(top: 160.0),
      decoration: new BoxDecoration(
          gradient: new LinearGradient(
        stops: [0.0, 1.0],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(0.0, 1.0),
        colors: <Color>[
          new Color(0),
          Colors.white,
        ],
      )),
    );
  }

  void _handleSelectedTopic(String selectedTopic) {
    // TODO implement _handleSelectedTopic.
    print("you selected $selectedTopic");
    // if(selectedTopic has notes available){
    //   showNotesNotFoundDialog
    // }
  }

  /// Returns a [ListView] that contains [ListTiles] for each available
  /// topic.
  Widget _getTopicsListView() {
    // If the topic list is still being loaded or happens to be empty,
    // show a [CircularProgressIndicator].
    if (topicsList == null) {
      return new CircularProgressIndicator();
    }

    return new ListView.builder(
      padding: new EdgeInsets.fromLTRB(0.0, 250.0, 0.0, 32.0),
      itemCount: topicsList.length,
      itemBuilder: (BuildContext context, int index) {
        String topicName = topicsList[index];
        return new Column(children: <Widget>[
          new Divider(),
          new ListTile(
            title: new Text(topicName),
            trailing: new Icon(
              Icons.arrow_forward_ios,
              size: 16.0,
            ),
            enabled: true,
            onTap: () => _handleSelectedTopic(topicName),
          ),
        ]);
      },
    );
  }

  Container _getToolbar(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: new BackButton(color: Colors.white),
    );
  }

  /// Despite the vastness of the internet, we have not managed to find notes
  /// for some topics, and in some cases, for entire subjects. So when a user
  /// tries to tap on a subject/topic which does not have any notes, we show an
  /// [AlertDialog] explaining the situation.
  ///
  /// (S)he can then file an issue or maybe even a PR. If the issue is popular,
  /// developers will put in added effort to find notes as per the request.
  Future<Null> showNotesNotFoundDialog() {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Sorry!'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Padding(padding: const EdgeInsets.only(top: 12.0)),
                new Text('''No notes for this topic or subject :(
\nThe good news is that you can request for it by filing an issue.'''),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('FILE ISSUE'),
              onPressed: () async {
                const url = 'https://github.com/MaskyS/studento/issues/';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not open $url. Check your internet connection and try again.';
                }
              },
            ),
            new FlatButton(
              child: new Text('OK'),
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
            ),
          ],
        );
      },
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

List topicsList;

class TopicSelectPage extends StatefulWidget {
  final String selectedSubject;
  final String level;
  TopicSelectPage(this.selectedSubject, this.level);
  @override
  _TopicSelectPageState createState() => new _TopicSelectPageState(selectedSubject, level);
}

class _TopicSelectPageState extends State<TopicSelectPage> {
  String selectedSubject;
  final String level;
  _TopicSelectPageState(this.selectedSubject, this.level);
  final List<String> listOfSubjects = ["General Paper AS", "French", "Mathematics", "Chemistry", "Physics", "Biology", "Economics", "Computer Science"];

  @override
  void initState() {
    getTopicsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        constraints: new BoxConstraints.expand(),
        child: new Stack(
        children: <Widget>[
          _getTopicsListView(),
          _getBackground(),
          _getGradient(),
          _getToolbar(context),
        ]),
      ),
    );
  }

  void getTopicsList() {
    rootBundle.loadString('assets/json/subjects_topic_lists.json')
    .then((String fileData){
      var _topicsList;
      Map topicsListData = json.decode(fileData);
      try {
        _topicsList = topicsListData[selectedSubject]['topic_list']['$level level'];
      } catch(e){
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
\nThe good news is that you can request for it by clicking on 'Send Feedback' from the drawer and filing an issue.'''),
                  ],
                ),
              ),
              actions: <Widget>[
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
      setState(() {
      topicsList = _topicsList;
      });
    });

  }

  Widget _getBackground() {
    final Widget subjectNameAndNoOfTopicsContainer = new Container(
      constraints: new BoxConstraints.expand(height: 250.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: (topicsList == null) ? <Widget>[new CircularProgressIndicator()]
        : <Widget>[
          new Text("$selectedSubject",
            textAlign: TextAlign.center,
            style: new TextStyle(
              fontFamily: 'Mina',
              color: Colors.white,
              fontSize: 30.0,
            ),
          ),
          new Padding(padding: const EdgeInsets.only(bottom: 4.0,)),
          new Text("${topicsList.length} topics",
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
          child: new Image.asset(
            "assets/images/physics-background-img.jpg", //subject.picture,
            fit: BoxFit.cover,
            height: 300.0,
          ),
          constraints: new BoxConstraints.expand(height: 250.0),
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
        )
      ),
    );
  }

  void _handleSelectedTopic(String selectedTopic){
    // TODO implement _handleSelectedTopic.
    print("you selected $selectedTopic");
  }

  Widget _getTopicsListView() {
    if (topicsList == null){
      return new CircularProgressIndicator();
    }

    return new ListView.builder(
      padding: new EdgeInsets.fromLTRB(0.0, 250.0, 0.0, 32.0),
      itemCount: topicsList.length,
      itemBuilder: (BuildContext context, int index){
        String topicName = topicsList[index];
        return new Column(children: <Widget>[
          new Divider(),
          new ListTile(
            title: new Text(topicName),
            trailing: new Icon(Icons.arrow_forward_ios, size: 16.0,),
            enabled: true,
            onTap: () =>_handleSelectedTopic(topicName),
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

}
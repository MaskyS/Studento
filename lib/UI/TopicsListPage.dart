import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'StudentoAppBar.dart';
List topicsList;

class SubjectTopicsListPage extends StatelessWidget {

  String selectedSubject;
  final String level;
  List<String> listOfSubjects = ["General Paper AS", "French", "Mathematics", "Chemistry", "Physics", "Biology", "Economics", "Computer Science"];
  SubjectTopicsListPage(this.selectedSubject, this.level);

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

   getTopicsList() {
    rootBundle.loadString('assets/json/subjects_topic_lists.json')
    .then((String fileData){
      Map topicsListData = json.decode(fileData);
      topicsList = topicsListData[selectedSubject]['topic_list']['$level level'];
    });
    return topicsList;
  }

  Widget _getBackground() {
    // TODO Turn this into a SliverAppBar for better mobility.
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
        new Container(
          constraints: new BoxConstraints.expand(height: 250.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
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
            ]
          )
        )

      ],
    );
  }

  Container _getGradient() {
    return new Container(
      margin: new EdgeInsets.only(top: 160.0),
      height: 90.0,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: <Color>[
            new Color(0x00),
            new Color(0xFFfefefe),
          ],
          stops: [0.0, 0.9],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
        )
      ),
    );
  }

  _handleSelectedTopic(String selectedTopic){
    // TODO implement _handleSelectedTopic.
  }

  Widget _getTopicsListView() {
    return new ListView.builder(
      padding: new EdgeInsets.fromLTRB(0.0, 250.0, 0.0, 32.0),
      itemBuilder: (BuildContext context, int index){
        String topicName = getTopicsList()[index];
        return new Stack(children: <Widget>[
          new ListTile(
            leading: new Text(index.toString()),
            title: new Text(topicName),
            trailing: new Icon(Icons.arrow_right),
            enabled: true,
            onTap: _handleSelectedTopic(topicName),
          ),
          new Divider(),
        ]);
      },
      itemCount: getTopicsList().length,
    );
  }

  Container _getToolbar(BuildContext context) {
    return new Container(
            margin: new EdgeInsets.only(
                top: MediaQuery
                    .of(context)
                    .padding
                    .top),
            child: new BackButton(color: Colors.white),
          );
  }

}
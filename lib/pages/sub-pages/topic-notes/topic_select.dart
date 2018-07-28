import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import '../../../UI/notes_not_found_dialog.dart';

import '../../../UI/studento_app_bar.dart';
import '../../../util/jaguar_launcher.dart';
import '../../../util/shared_prefs_interface.dart';

class TopicSelectPage extends StatefulWidget {
  /// The subject which was selected from the user's subject list.
  /// We'll be showing the topics for this subject only on this page.
  final String selectedSubject;

  /// Level of user. i.e O level/A level. 
  final String level;
  
  TopicSelectPage(
    this.selectedSubject, 
    this.level
  );

  @override
  _TopicSelectPageState createState() => _TopicSelectPageState();
}

class _TopicSelectPageState extends State<TopicSelectPage> {

  /// The List of topics of the selected subject.
  List topicsList;

  /// The syllabus code of the selected subject.  
  String subjectCode;

  @override
  void initState() {
    super.initState();
    JaguarLauncher.startLocalServer(serverPort: 8090);
    getTopicsList();
    getSubjectCode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        child: Stack(children: <Widget>[
          _getTopicsListView(),
          _getBackground(),
          _getGradient(),
          _getToolbar(context),
        ]),
      ),
    );
  }

  void getSubjectCode() async {
    List<String> subjectCodesList = await SharedPreferencesHelper.getSubjectsCodesList();
    List<String> subjectsList = await SharedPreferencesHelper.getSubjectsList();

    int indexOfSubjectCode = subjectsList.indexOf(widget.selectedSubject);
    subjectCode  = subjectCodesList[indexOfSubjectCode];
  }

  void getTopicsList() async {
    List _topicsList;
    String _topicsListData =
        await rootBundle.loadString('assets/json/subjects_topic_lists.json');
    Map topicsListData = json.decode(_topicsListData);

    try {
      _topicsList =
          topicsListData[widget.selectedSubject]['topic_list']['${widget.level}'];

    } catch (e) {
      showNotesNotFoundDialog();
    }
    setState(() => topicsList = _topicsList);
  }

  Widget _getBackground() {
  
    Widget buildBackgroundImage() => Container(
      constraints: BoxConstraints.expand(height: 250.0),
      child: Image.asset(
        "assets/images/physics-background-img.jpg", //subject.picture,
        fit: BoxFit.cover,
        height: 300.0,
      ),
    );
  
    Widget buildOverviewContainer() {
      if (topicsList == null) {
        return Center(child: CircularProgressIndicator());
      }
      return Container(
        constraints: BoxConstraints.expand(height: 250.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "${widget.selectedSubject}",
              textAlign: TextAlign.center,
            ),
            Padding(padding: EdgeInsets.only(bottom: 4.0)),
            Text(
              "${topicsList.length} topics",
              textScaleFactor: 1.2,
              style: TextStyle(  
                color: Color(0xFFFefefe),
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
              )
              // TODO Add style from https://github.com/MaskyS/studento/commit/08f0c77b8d5830b42223da057b9932f3143de25e
            )
          ],
        ),
      );
    }

    // TODO Turn this into a SliverAppBar for better mobility.
    // Also, instead of the background image let's get some fancy animation
    // like https://www.youtube.com/watch?v=MAET-z1apKA on a dark purple
    // background or the like.
    return Stack(
      children: <Widget>[
        buildBackgroundImage(),
        buildOverviewContainer(),
      ],
    );
  }

  Widget _getGradient() {
    return Container(
      height: 90.0,
      margin: EdgeInsets.only(top: 160.0),
      decoration: BoxDecoration(
          gradient: LinearGradient(
        stops: [0.0, 1.0],
        begin: FractionalOffset(0.0, 0.0),
        end: FractionalOffset(0.0, 1.0),
        colors: <Color>[
          Color(0),
          Colors.white,
        ],
      )),
    );
  }

  void _handleSelectedTopic(String selectedTopic) {
    String url = "http://localhost:8090/html/topic-notes/$subjectCode/$selectedTopic.html";
    print("you selected $selectedTopic");
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WebviewScaffold(
          url: url,
          withZoom: true,
          appBar: StudentoAppBar(title: "View Topic"),
        ),
      ),
    );
  }

  /// Returns a [ListView] that contains [ListTiles] for each available
  /// topic.
  Widget _getTopicsListView() {
    // If the topic list is still being loaded or happens to be empty,
    // show a [CircularProgressIndicator].
    if (topicsList == null) {
      return CircularProgressIndicator();
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(0.0, 250.0, 0.0, 32.0),
      itemCount: topicsList.length,
      itemBuilder: (BuildContext context, int index) {
        String topicName = topicsList[index];
        return Column(children: <Widget>[
          Divider(),
          ListTile(
            title: Text(topicName),
            trailing: Icon(
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
    return Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top),
      child: BackButton(color: Colors.white),
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
      builder: (_) => NotesNotFoundAlertDialog(),
    );
  }
}

import 'package:flutter/material.dart';
import '../UI/studento_app_bar.dart';
import '../UI/studento_drawer.dart';
import '../UI/subjects_staggered_grid_view.dart';
import '../pages/sub-pages/topic-notes/topic_select.dart';

class TopicNotesPage extends StatefulWidget {
  @override
  _TopicNotesPageState createState() => new _TopicNotesPageState();
}

class _TopicNotesPageState extends State<TopicNotesPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new StudentoAppBar(
        title: new Text("Topic Notes",
        style: TextStyle(color: Colors.white),
      ),
      ),
      drawer: new StudentoDrawer(),
      body: new SubjectsStaggeredListView(openTopicsListPage),
    );
  }

  void openTopicsListPage(String subject, String level) {
    // Open topic_select page, which displays the topic list for the selected
    // subject.
    Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (BuildContext context) =>
              new TopicSelectPage(subject, level)),
    );
  }
}

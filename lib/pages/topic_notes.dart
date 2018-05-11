import 'package:flutter/material.dart';
import '../UI/studento_app_bar.dart';
import '../UI/studento_drawer.dart';
import '../UI/subjects_staggered_grid_view.dart';

class TopicNotesPage extends StatefulWidget {
  @override
  _TopicNotesPageState createState() => new _TopicNotesPageState();
}

class _TopicNotesPageState extends State<TopicNotesPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new StudentoAppBar(
        title: new Text("Topic Notes"),
      ),
      drawer: new StudentoDrawer(),
      body: new SubjectsStaggeredListView('topicNotesPage'),
    );
  }
}

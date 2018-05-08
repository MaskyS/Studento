import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../UI/studento_app_bar.dart';
import '../UI/studento_drawer.dart';
import '../UI/subjects_staggered_grid_view.dart';

class PastPapersPage extends StatefulWidget {
  static String routeName = "past_papers_page";
  @override
  _PastPapersPageState createState() => new _PastPapersPageState();

}

class _PastPapersPageState extends State<PastPapersPage> {

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      drawer: new StudentoDrawer(),
      body: new SubjectsStaggeredListView('pastPapersPage'),
      appBar: new StudentoAppBar(
        title: new Text('Past Papers'),
      ),
    );
  }

}
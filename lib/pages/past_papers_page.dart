import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../UI/studento_app_bar.dart';
import '../UI/studento_drawer.dart';
import '../UI/subjects_staggered_grid_view.dart';
import '../pages/sub-pages/past-papers/past_paper_details_select.dart';

class PastPapersPage extends StatefulWidget {
  @override
  _PastPapersPageState createState() => new _PastPapersPageState();
}

class _PastPapersPageState extends State<PastPapersPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new StudentoDrawer(),
      body: new SubjectsStaggeredListView(openPastPapersDetailsSelect),
      appBar: new StudentoAppBar(
        title: new Text('Past Papers'),
      ),
    );
  }

  void openPastPapersDetailsSelect(String subject, String level) {
    // Open the past_paper_details_select page.
    Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (BuildContext context) =>
              new PaperDetailsSelectionPage(subject, level)),
    );
  }
}

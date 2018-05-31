import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../UI/studento_app_bar.dart';
import '../UI/studento_drawer.dart';
import '../UI/subjects_staggered_grid_view.dart';
import '../pages/sub-pages/past-papers/past_paper_details_select.dart';

class PastPapersPage extends StatefulWidget {
  @override
  _PastPapersPageState createState() => _PastPapersPageState();
}

class _PastPapersPageState extends State<PastPapersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: StudentoDrawer(),
      appBar: StudentoAppBar(title: 'Past Papers'),
      body: SubjectsStaggeredListView(openPastPapersDetailsSelect),
    );
  }

  void openPastPapersDetailsSelect(String subject, String level) {
    // Open the past_paper_details_select page.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
          PaperDetailsSelectionPage(subject, level)
      ),
    );
  }
}

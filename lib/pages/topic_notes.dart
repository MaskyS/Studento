// import 'package:flutter/material.dart';
// import '../UI/studento_app_bar.dart';
// import '../UI/studento_drawer.dart';
// import '../UI/subjects_staggered_grid_view.dart';
// import '../pages/sub-pages/topic-notes/topic_select.dart';
// import '../model/subject.dart';

// class TopicNotesPage extends StatefulWidget {
//   @override
//   _TopicNotesPageState createState() => _TopicNotesPageState();
// }

// class _TopicNotesPageState extends State<TopicNotesPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: StudentoDrawer(),
//       appBar: StudentoAppBar(title: "Topic Notes"),
//       body: SubjectsStaggeredListView(openTopicsListPage),
//     );
//   }

//   void openTopicsListPage(Subject subject) {
//     // Open topic_select page, which displays the topic list for the selected
//     // subject.
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (BuildContext context) => TopicSelectPage(subject)
//       ),
//     );
//   }
// }

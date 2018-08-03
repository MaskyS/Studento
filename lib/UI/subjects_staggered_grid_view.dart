import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../util/shared_prefs_interface.dart';
import '../UI/loading_page.dart';
import '../model/subject.dart';

class SubjectsStaggeredListView extends StatefulWidget {
  SubjectsStaggeredListView(this.onGridTileTap);

  /// The function to execute when a GridTile is
  /// tapped.
  final Function(Subject subject) onGridTileTap;

  @override
  _SubjectsStaggeredListViewState createState() =>
      _SubjectsStaggeredListViewState();
}

class _SubjectsStaggeredListViewState extends State<SubjectsStaggeredListView> {
  List<Subject> subjects;

  final List<StaggeredTile> _staggeredTiles = const <StaggeredTile>[
    StaggeredTile.count(2, 1),
    StaggeredTile.count(2, 2),
    StaggeredTile.count(2, 2),
    StaggeredTile.count(2, 2),
    StaggeredTile.count(2, 1),
    StaggeredTile.count(2, 2),
    StaggeredTile.count(2, 1),
    StaggeredTile.count(2, 1),
    StaggeredTile.count(2, 2),
    StaggeredTile.count(2, 2),
    StaggeredTile.count(2, 2),
    StaggeredTile.count(2, 1),
    StaggeredTile.count(2, 2),
    StaggeredTile.count(2, 1),
    StaggeredTile.count(2, 2),
    StaggeredTile.count(2, 2),
    StaggeredTile.count(2, 2),
  ];

  @override
  void initState() {
    super.initState();
    getSubjects();
  }

  List<Subject> getSubjects() {
    List<String>_subjectsNamesList;
    List<String> _subjectCodesList;

    SharedPreferencesHelper.getSubjectsList().then(
        (List<String> subjeccts) => _subjectsNamesList = subjeccts);

    SharedPreferencesHelper.getSubjectsCodesList().then(
        (List<String> coddes) => _subjectCodesList = coddes);

    int i = 0;
    _subjectsNamesList.forEach((String subject) {
      int subjectCode = int.parse(_subjectCodesList[i]);
      setState(() => subjects.add(Subject(subject, subjectCode)));
      i++;
    });

    return subjects;
  }

  @override
  Widget build(BuildContext context) {
    List<_SubjectTile> subjectTiles = [];

    if (subjects == null) return loadingPage();

    /// Add tiles for each subject into [subjectTiles].
    subjects.forEach((Subject subject){
      subjectTiles.add(_SubjectTile(subject, widget.onGridTileTap));
    });

    return Padding(
      padding: EdgeInsets.only(top: 12.0),
      child: StaggeredGridView.count(
        crossAxisCount: 4,
        staggeredTiles: _staggeredTiles,
        children: subjectTiles,
      ),
    );
  }
}

class _SubjectTile extends StatelessWidget {

  /// The subject the tile will be displaying.
  final Subject subject;

  /// This callback function will be executed when GridTile is
  /// tapped.
  final Function(Subject subject) onTapFunction;

  const _SubjectTile(
    this.subject,
    this.onTapFunction,
  );

  /// Prettifies the subject name by converting the name to uppercase and
  /// breaking lengthy names into two lines.
  String prettifySubjectName(String subjectName) {
    subjectName = subjectName.toUpperCase();
    subjectName = subjectName.replaceFirst(" ", " \n");
    return subjectName;
  }

  @override
  Widget build(BuildContext context) {

    void showHelpTextWhenLongPressed() {
      String msg = "Tap the subject you seek.";
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(msg)));
    }

    const LinearGradient backgroundGradient = LinearGradient(
      begin: FractionalOffset(0.0, 0.0),
      end: FractionalOffset(2.0, 0.0),
      stops: [0.0, 0.5],
      tileMode: TileMode.clamp,
      colors: [
        Colors.deepPurpleAccent,
        Color(0xFF5fbff9), // Imperialish blue.
      ],
    );

    TextStyle subjectNameStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    Widget subjectNameText = Text(
      prettifySubjectName(subject.name),
      textAlign: TextAlign.center,
      textScaleFactor: 1.1,
      overflow: TextOverflow.fade,
      style: subjectNameStyle,
    );

    return Card(
      elevation: 2.0,
      child: InkWell(
        onTap: onTapFunction(subject),
        onLongPress: showHelpTextWhenLongPressed,
        child: Container(
          child: Center(child: subjectNameText),
          padding: EdgeInsets.symmetric(
            vertical: 18.0,
            horizontal: 5.0,
          ),
          decoration: BoxDecoration(
            gradient: backgroundGradient,
            border: Border.all(color: Colors.black54, width: 2.0),
          ),
        ),
      ),
    );
  }
}

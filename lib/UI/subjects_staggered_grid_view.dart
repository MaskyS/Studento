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
  List<Subject> subjects = [];
  List<Widget> subjectTiles = [];
  bool isSubjectsLoaded = false;

  @override
  void initState() {
    super.initState();
    getSubjects();
  }

  void getSubjects() async{
    List<String>_subjectsNamesList;
    List<String> _subjectCodesList;

    _subjectsNamesList = await SharedPreferencesHelper.getSubjectsList();
    _subjectCodesList = await SharedPreferencesHelper.getSubjectsCodesList();

    int i = 0;
    _subjectsNamesList.forEach((String subjectName) {
      int subjectCode = int.parse(_subjectCodesList[i]);
      Subject _subject = Subject(subjectName, subjectCode);
      subjects.add(_subject);
      i++;
    });

    /// Add tiles for each subject into [subjectTiles].
    subjects.forEach((Subject subject){
        print("The subject about to be passed down from ListView is $subject");
        // subjectTiles.add(_SubjectTile(subject, widget.onGridTileTap));
    });

    setState(() => isSubjectsLoaded = true);

  }

  @override
  Widget build(BuildContext context) {
    if (!isSubjectsLoaded) return loadingPage();

    Widget subjectTilesBuilder() => StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      itemCount: subjects.length,
      itemBuilder: (_, int i) => buildSubjectTile(subjects[i]),
      staggeredTileBuilder: (int i) =>
          StaggeredTile.count(2, i.isEven ? 2 : 1),
    );

    return Padding(
      padding: EdgeInsets.only(top: 12.0),
      child: subjectTilesBuilder(),
    );
  }

  Widget buildSubjectTile(Subject subject) {
    const LinearGradient backgroundGradient = LinearGradient(
      begin: FractionalOffset(0.0, 0.0),
      end: FractionalOffset(2.0, 0.0),
      stops: [0.0, 0.5],
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

    return Material(
      elevation: 2.0,
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: backgroundGradient,
          border: Border.all(color: Colors.black54, width: 2.0),
        ),
        child: InkWell(
          onTap: () => widget.onGridTileTap(subject),
          child: Center(child: subjectNameText),
        ),
      ),
    );
  }

  /// Prettifies the subject name by converting the name to uppercase and
  /// breaking lengthy names into two lines.
  String prettifySubjectName(String subjectName) {
    subjectName = subjectName.toUpperCase();
    subjectName = subjectName.replaceFirst(" ", " \n");
    return subjectName;
  }

}
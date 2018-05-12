import 'package:flutter/material.dart';
import 'package:studentapp/globals.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SubjectsStaggeredListView extends StatefulWidget {
  final List<StaggeredTile> _staggeredTiles = const <StaggeredTile>[
    const StaggeredTile.count(2, 1),
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(2, 1),
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(2, 1),
    const StaggeredTile.count(2, 1),
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(2, 2),
  ];

  /// This specifies which function to execute when a GridTile is
  /// tapped.
  final Function(String subject, String level) onTapFunction;
  SubjectsStaggeredListView(this.onTapFunction);


  @override
  _SubjectsStaggeredListViewState createState() =>
      new _SubjectsStaggeredListViewState();
}

class _SubjectsStaggeredListViewState extends State<SubjectsStaggeredListView> {
  Map urlList;
  // TODO Once we get Shared Pref up and running, we should fetch the list of
  // subjects. Updated code should look like:
  //
  // SharedPreferences userConfig = await SharedPreferences.getInstance();
  // userConfig.getString("level");
  // List listOfSubjects = userConfig.getStringList("list_of_subjects");
  // Get the url from our subjects_syllabus_urls.json file.
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<_SubjectTile> subjectTiles = [];

    /// Add tiles for each subject into [subjectTiles].
    for (String subject in subjectsList) {
      subjectTiles.add(_SubjectTile(subject, widget.onTapFunction));
    }

    return new Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: new StaggeredGridView.count(
          crossAxisCount: 4,
          staggeredTiles: widget._staggeredTiles,
          children: subjectTiles,
        ));
  }
}

class _SubjectTile extends StatelessWidget {
  /// The name of the subject the tile will be displaying.
  final String subjectName;
  const _SubjectTile(
    this.subjectName,
    this.onTapFunction,
  );

  /// This callback function will be executed when GridTile is
  /// tapped.
  final Function(String subject, String level) onTapFunction;

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: new Color(0xFFf9f9f9),
      elevation: 2.0,
      child: new InkWell(
        highlightColor: Colors.blue[700],
        onTap: () => onTapFunction(subjectName, level),
        onLongPress: () => Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text("Tap the subject you seek."),
            )),
        child: new Container(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 5.0),
          decoration: new BoxDecoration(
            border: new Border.all(
              color: Colors.blue,
              width: 2.0,
            ),
          ),
          child: new Center(
            child: new Text(
              prettifySubjectName(subjectName),
              textAlign: TextAlign.center,
              textScaleFactor: 1.1,
              overflow: TextOverflow.fade,
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Prettifies the subject name by converting the name to uppercase and
  /// breaking lengthy names into two lines.
  String prettifySubjectName(String subjectName) {
    subjectName = subjectName.toUpperCase();
    // We determine if the subject name is lengthy by checking if it contains a space,
    // then split the name into two lines for better aesthetic.
    subjectName = subjectName.replaceFirst(" ", " \n");
    return subjectName;
  }
}

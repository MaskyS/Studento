import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../util/shared_prefs_interface.dart';

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
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(2, 1),
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(2, 1),
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(2, 2),
  ];

  /// This specifies which function to execute when a GridTile is
  /// tapped.
  final Function(String subject, String level) onTapFunction;
  SubjectsStaggeredListView(this.onTapFunction);


  @override
  _SubjectsStaggeredListViewState createState() =>
    _SubjectsStaggeredListViewState();
}

class _SubjectsStaggeredListViewState extends State<SubjectsStaggeredListView> {
  Map urlList;
  List<String> subjectsList;
  String level;

  getUserData() async{
    List<String> _subjectsList = await SharedPreferencesHelper.getSubjectsList();
    String _level = await SharedPreferencesHelper.getLevel();
    setState(() {
      subjectsList = _subjectsList;
      level = _level;
    });

  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<_SubjectTile> subjectTiles = [];

    if (subjectsList == null){
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    /// Add tiles for each subject into [subjectTiles].
    for (String subject in subjectsList) {
      subjectTiles.add(_SubjectTile(subject, level, widget.onTapFunction));
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: StaggeredGridView.count(
        crossAxisCount: 4,
        staggeredTiles: widget._staggeredTiles,
        children: subjectTiles,
      ),
    );
  }
}

class _SubjectTile extends StatelessWidget {
  /// The name of the subject the tile will be displaying.
  final String subjectName;
  final String level;
  const _SubjectTile(
    this.subjectName,
    this.level,
    this.onTapFunction,
  );

  /// This callback function will be executed when GridTile is
  /// tapped.
  final Function(String subject, String level) onTapFunction;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: InkWell(
        onTap: () => onTapFunction(subjectName, level),
        onLongPress: () => Scaffold
          .of(context)
          .showSnackBar(SnackBar(
              content: Text("Tap the subject you seek."),
          )
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 5.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(2.0, 0.0),
              stops: [0.0, 0.5],
              tileMode: TileMode.clamp,
              colors: [
                Colors.deepPurpleAccent,
                Color(0xFF5fbff9),
              ],
            ),
            border: Border.all(color: Colors.black54, width: 2.0),
          ),
          child: Center(
            child: Text(
              prettifySubjectName(subjectName),
              textAlign: TextAlign.center,
              textScaleFactor: 1.1,
              overflow: TextOverflow.fade,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
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

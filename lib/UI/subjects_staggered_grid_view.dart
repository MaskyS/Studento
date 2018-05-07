import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../utils/subjects_staggered_grid_view_functions.dart' as gridViewFunctions;


List<StaggeredTile> _staggeredTiles = const <StaggeredTile>[
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

String level = 'O';
List<String> subjectsList = ['Maths', 'French', 'Additional Mathematics', 'English', 'Design & Technology', 'Computer Science', "Hello World", "Damn Son", "Hello Torma", "Testing World"];
List<Widget> subjectTiles = [];

class SubjectsStaggeredListView extends StatefulWidget {

  /// This specifies which function to execute when a GridTile is
  /// tapped.
  final String onTapFunction;
  SubjectsStaggeredListView(this.onTapFunction);

  @override
  _SubjectsStaggeredListViewState createState() => new _SubjectsStaggeredListViewState();
}

class _SubjectsStaggeredListViewState extends State<SubjectsStaggeredListView> {

  @override
  Widget build(BuildContext context) {
    /// Add tiles for each subject into [subjectTiles].
    for (String subject in subjectsList) {
      subjectTiles.add(_SubjectTile(subject, widget.onTapFunction)) ;
    }

    return new Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: new StaggeredGridView.count(
        crossAxisCount: 4,
        staggeredTiles: _staggeredTiles,
        children: subjectTiles,
      )
    );
  }

}

class _SubjectTile extends StatelessWidget {

  /// The name of the subject the tile will be displaying.
  final String subjectName;

  /// This String specifies which function to execute when a GridTile is
  /// tapped.
  final String onTapFunction;

  const _SubjectTile(this.subjectName, this.onTapFunction);

  @override
  Widget build(BuildContext context) {
    return new Card(
      elevation: 0.0,
      child: new InkWell(
        onTap: () => gridViewFunctions.handleonTap(context, subjectName, level, onTapFunction),
        onLongPress: () => Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text("Tap the subject you seek."),
        )),
        child: new Container(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 5.0),
          decoration: new BoxDecoration(
            border: new Border.all(
              color: Colors.blue[900],
              width: 2.0,
            ),
            color: Colors.blue,
          ),
          child: new Center(
            child: new  Text(
              gridViewFunctions.prettifySubjectName(subjectName),
              textAlign: TextAlign.center,
              textScaleFactor: 1.2,
              overflow: TextOverflow.fade,
              style: new TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }


}



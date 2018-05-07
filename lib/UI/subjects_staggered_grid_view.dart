import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
List<String> subjectsList = ['Mathematics D', 'Sociology', 'Additional Mathematics', 'Literature in English', 'Design & Technology', 'Computer Studies', "Biology", "chemistry", "Accounting", "Economics"];
List<Widget> subjectTiles = [];
Map urlList;
class SubjectsStaggeredListView extends StatefulWidget {
  /// This specifies which function to execute when a GridTile is
  /// tapped.
  final String onTapFunction;
  SubjectsStaggeredListView(this.onTapFunction);

  @override
  _SubjectsStaggeredListViewState createState() => new _SubjectsStaggeredListViewState();
}

class _SubjectsStaggeredListViewState extends State<SubjectsStaggeredListView> {
    // TODO Once we get Shared Pref up and running, we should fetch the list of
    // subjects. Updated code should look like:
    //
    // SharedPreferences userConfig = await SharedPreferences.getInstance();
    // userConfig.getString("level");
    // List listOfSubjects = userConfig.getStringList("list_of_subjects");
    // Get the url from our subjects_syllabus_urls.json file.
  @override
  void initState() {
    rootBundle.loadString('assets/json/subjects_syllabus_urls.json').then((fileData){
      urlList = json.decode(fileData);
    });
    super.initState();
  }
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

  const _SubjectTile(this.subjectName, this.onTapFunction,);

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: new Color(0xFFf9f9f9),
      elevation: 2.0,
      child: new InkWell(
        highlightColor: Colors.blue[700],
        onTap: () => gridViewFunctions.handleonTap(context, subjectName, level, onTapFunction, urlList: urlList),
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
            child: new  Text(
              gridViewFunctions.prettifySubjectName(subjectName),
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


}



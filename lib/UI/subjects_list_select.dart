import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../util/shared_prefs_interface.dart';

/// Builds a [ListView] containing [CheckBoxListTiles] for each of the
/// subjects.
class SubjectsList extends StatefulWidget {
  @override
  _SubjectsListState createState() => new _SubjectsListState();
}

class _SubjectsListState extends State<SubjectsList> {
  String selectedLevel;
  List<String> selectedSubjects = [];
  Map<String, dynamic> decodedSubjectData;
  List<Map<String, dynamic>> listOfSubjects = [];

  @override
  initState(){
    // Get the level of the user.
    SharedPreferencesHelper.getLevel().then(
      (String level) => selectedLevel = level
    );
    getSubjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listOfSubjects.length,
      itemBuilder: (_, int index) {
        Map<String, dynamic> currentSubject = listOfSubjects[index];
        return CheckboxListTile(
          activeColor: Colors.blue[700],
          value: currentSubject["selected"],
          selected: currentSubject["selected"],
          title: Text(currentSubject["subject_name"]),
          secondary: Text(currentSubject["subject_code"]),
          onChanged: (bool isSelected)
            {
              setState(() {
                listOfSubjects[index]["selected"] = isSelected;
                if (isSelected){
                  selectedSubjects.add(currentSubject["subject_name"]);
                }
                else{
                  selectedSubjects.removeWhere((String subject) => subject == currentSubject["subject_name"]);
                }
                print(selectedSubjects);
                SharedPreferencesHelper.setSubjectsList(selectedSubjects);
              });
            },
        );
      }
    );
  }

  /// Gets all the subjects and their component code Studento offers, and pushes
  /// them into [listOfSubjects].
  void getSubjects() async {
    String subjectData = await rootBundle.loadString("assets/json/subjects_list.json");
    decodedSubjectData = json.decode(subjectData);

    setState(() {
      for (var index = 0; index < decodedSubjectData[selectedLevel].length; index++) {

        /// [currentSubject]  being added to listOfSubjects is a Map, whose keys
        /// are Strings, and values are dynamic:
        ///   - ["subject_name"] key's values are Strings
        ///   - ["subject_code"] key's values are Strings
        ///   - [selected] key's values are boolean, indicates whether or not
        ///  user has selected this subject from the list of subjects.
        Map<String, dynamic> currentSubject = decodedSubjectData[selectedLevel][index];
        listOfSubjects.add(
          {
          "subject_name" : currentSubject["subject_name"],
          "subject_code" : currentSubject["subject_code"],
          "selected": false,
          }
        );
      }
    });

  }

}
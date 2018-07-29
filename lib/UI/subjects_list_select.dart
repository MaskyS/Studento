import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../util/shared_prefs_interface.dart';

/// Builds a [ListView] containing [CheckBoxListTiles] for each of the
/// subjects.
class SubjectsList extends StatefulWidget {
  @override
  _SubjectsListState createState() => _SubjectsListState();
}

class _SubjectsListState extends State<SubjectsList> {
  String selectedLevel;
  List<String> selectedSubjects = [];
  List<String> selectedSubjectsCodes = [];
  Map<String, dynamic> decodedSubjectData;
  List<Map<String, dynamic>> listOfSubjects = [];

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

  @override
  initState(){
    super.initState();
    // Get the level of the user.
    SharedPreferencesHelper.getLevel().then(
      (String level) => selectedLevel = level
    );
    getSubjects();
  }

    /// Temporary workaround to store subjects and their codes
    // kinda together. I know, terrible data architecture. But hey,
    /// this is for the sake of SQ. TODO Fix this through database
    /// implementation or by using 1 or 2 json files ONLY.
  void addOrRemoveSubjectFromSubjectsList(bool isSelected, int index, String subjectName, String subjectCode) {
    setState(() {
      listOfSubjects[index]["selected"] = isSelected;
      if (isSelected) {
        selectedSubjects.add(subjectName);
        selectedSubjectsCodes.add(subjectCode);
      }
      else{
        selectedSubjects.removeWhere((String subject) => subject == subjectName);
        selectedSubjects.removeWhere((String _subjectCode) => _subjectCode == subjectCode);
      }
      print(selectedSubjects);
      print(selectedSubjectsCodes);
      SharedPreferencesHelper.setSubjectsList(selectedSubjects);
      SharedPreferencesHelper.setSubjectsCodesList(selectedSubjectsCodes);
    });
  }
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> currentSubject;
    return ListView.builder(
      itemCount: listOfSubjects.length,
      itemBuilder: (_, int index) {

        currentSubject = listOfSubjects[index];
        String subjectName  = currentSubject["subject_name"];
        String subjectCode = currentSubject["subject_code"];
        bool isSubjectSelected = currentSubject['selected'];

        return CheckboxListTile(
          activeColor: Color(0xFF5fbff9),
          value: isSubjectSelected,
          selected: isSubjectSelected,
          title: Text(subjectName),
          secondary: Text(subjectCode),
          onChanged: (bool isSelected) 
              => addOrRemoveSubjectFromSubjectsList(
                isSelected, 
                index, 
                subjectName, 
                subjectCode
          ),
        );
      }
    );
  }

}
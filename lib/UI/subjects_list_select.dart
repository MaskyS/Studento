import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../util/shared_prefs_interface.dart';

import 'loading_page.dart';
import '../model/subject.dart';

/// Builds a [ListView] containing [CheckBoxListTiles] for each of the
/// subjects.
class SubjectsList extends StatefulWidget {
  @override
  _SubjectsListState createState() => _SubjectsListState();
}

class _SubjectsListState extends State<SubjectsList> {

  String selectedLevel;

  /// Holds decoded data from json file. We can't directly use this, because
  /// it contains subjects for both levels.
  Map<String, dynamic> decodedSubjectData;

  /// Actual type: [Map<String, dynamic>]
  /// Because of json_decode, can't strong type this.
  List<dynamic> _subjectsList;

  /// The list of subjects available to the user for his level.
  List<Subject> subjects = [];

  /// The list of subjects the user has selected and is studying.
  List<Subject> selectedSubjects = [];

  void getSubjects() async{

    String subjectData = await rootBundle.loadString("assets/json/subjects_list.json");
    decodedSubjectData = json.decode(subjectData);

    /// Filter out the subjects that aren't for the user's level.
    _subjectsList = decodedSubjectData[selectedLevel];

    print(_subjectsList);

    setState(() {
      for (var subject in _subjectsList) {
        subjects.add(
          Subject.fromMap(subject)
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

  /// By this time you are surely wondering why the hell we need to copy
  /// these values to different lists again. Well, that's because we're
  /// storing the user's subjects( and thus their codes) using shared
  /// preferences plugin. Unfortunately for us, that doesn't support Lists
  /// of other types, or Maps. I know this sucks, but you can change that
  /// by sending a PR! :D
  void saveSelectedSubjects(List<String> subjectNames, List<String> subjectCodes) {
      SharedPreferencesHelper.setSubjectsList(subjectNames);
      SharedPreferencesHelper.setSubjectsCodesList(subjectCodes);
  }

  void addOrRemoveSubjectFromSelectedSubjectsList(bool isSelected, int index) {
    print("${subjects[index].toString}");
    setState(() {
      subjects[index].isSelected = isSelected;

      if (isSelected) {
        selectedSubjects.add(subjects[index]);
      }
      else{
        selectedSubjects.removeWhere((Subject _subject) => _subject == subjects[index]);
      }
      print("selected subjects are: $selectedSubjects");

      List<String> selectedSubjectNames = [];
      List<String> selectedSubjectCodes = [];

      selectedSubjects.forEach((Subject subject) {
        selectedSubjectNames.add(subject.name);
        selectedSubjectCodes.add(subject.subjectCode.toString());
      });

      saveSelectedSubjects(selectedSubjectNames, selectedSubjectCodes);
    });
  }

  @override
  Widget build(BuildContext context) {

    if (_subjectsList == null) return loadingPage();

    Subject currentSubject;
    return ListView.builder(
      itemCount: subjects.length,
      itemBuilder: (_, int index) {

        currentSubject = subjects[index];
        String subjectName  = currentSubject.name;
        int subjectCode = currentSubject.subjectCode;
        bool isSubjectSelected = currentSubject.isSelected;

        return CheckboxListTile(
          activeColor: Color(0xFF5fbff9),
          value: isSubjectSelected,
          selected: isSubjectSelected,
          title: Text(subjectName),
          secondary: Text("$subjectCode"),
          onChanged: (bool isSelected) => addOrRemoveSubjectFromSelectedSubjectsList(
            isSelected,
            index,
          ),
        );
      }
    );
  }

}
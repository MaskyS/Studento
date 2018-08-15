import 'package:flutter/material.dart';

import '../../../util/shared_prefs_interface.dart';
import '../../../util/show_message_dialog.dart' show showMessageDialog;
import '../../../UI/subjects_list_select.dart';
import '../../../UI/setup_page.dart';
import 'classes_setup.dart';

class SubjectsSetup extends StatefulWidget {
  @override
  _SubjectsSelectSetupState createState() => _SubjectsSelectSetupState();
}

class _SubjectsSelectSetupState extends State<SubjectsSetup> {

  List<String> subjectsList;

  @override
  Widget build(BuildContext context) {
    return SetupPage(
      leadIcon: Icons.book,
      title: "Subjects",
      subtitle: "Choose your subjects below:",
      body: SubjectsList(),
      onFloatingButtonPressed: validateAndPushSessionsPage,
    );
  }

  void validateAndPushSessionsPage() async {
    subjectsList = await SharedPreferencesHelper.getSubjectsList();
    validateSelectedSubjects();
  }

  void validateSelectedSubjects() {
    bool _isSelectedSubjectsCorrect = (
      subjectsList.isNotEmpty &&
        subjectsList != null &&
          subjectsList.length >= 4);

    if (_isSelectedSubjectsCorrect) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ClassesSetup()));

    } else showMessageDialog(
        context,
        msg: "You need to select 4 or more subjects.",
      );
  }
}
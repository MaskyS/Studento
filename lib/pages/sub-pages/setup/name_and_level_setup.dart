import 'package:flutter/material.dart';

import '../../../util/shared_prefs_interface.dart';
import '../../../util/show_message_dialog.dart';
import '../../../UI/setup_page.dart';
import 'subjects_setup.dart';

class NameAndLevelSetup extends StatefulWidget {
  @override
  _NameAndLevelSetupState createState() => _NameAndLevelSetupState();
}

class _NameAndLevelSetupState extends State<NameAndLevelSetup> {

  /// [TextEditingController] for the name [TextField].
  final TextEditingController _nameController = TextEditingController();

  /// Error text that appears under the name [TextField] when there are issues.
  String _errorText;

  String selectedLevel;

  bool isLevelValidationSuccess = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SetupPage(
      leadIcon: Icons.person_pin,
      title: "Introductions",
      subtitle: "How should we call you, awesome user?",
      body: _buildInfoBody(),
      onFloatingButtonPressed: validateAndPushSubjectsPage,
    );
  }

  ListView _buildInfoBody() => ListView(
    children: <Widget>[
      buildTextField(),
      Padding(padding: EdgeInsets.only(top: 25.0)),
      Text(
        "Which Cambridge International Examination are you taking part in?",
        style: TextStyle(color: Colors.black54),
      ),
      oLevelRadioListTile(),
      aLevelRadioListTile(),
    ],
  );

  Widget buildTextField() => TextField(
    controller: _nameController,
    keyboardType: TextInputType.text,
    onSubmitted: validateName,
    onChanged: validateName,
    decoration: nameTextFieldDeco(),
  );

  InputDecoration nameTextFieldDeco() => InputDecoration(
    errorStyle: TextStyle(color: Colors.redAccent),
    errorText: _errorText,
    labelText: "Name",
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.deepPurpleAccent),
    ),
  );

  Widget buildLevelRadioListTile(String level) => RadioListTile(
    title: Text(level),
    value: level,
    groupValue: selectedLevel,
    selected: false,
    onChanged: (String level) => setState(() => selectedLevel = level),
  );

  Widget oLevelRadioListTile() => buildLevelRadioListTile("O level");
  Widget aLevelRadioListTile() => buildLevelRadioListTile("A level");

  void validateAndPushSubjectsPage() {
    validateName(_nameController.text);
    validateSelectedLevel();
    if (isLevelValidationSuccess && _errorText == null) {
      saveInputtedData();
      pushSubjectsPage();
    }

  }

  void validateName(String name) {
    bool isNameIncorrect = (
      name == null ||
      name.isEmpty ||
      name.replaceAll(' ', '').isEmpty || // If contains only spaces.
      name.contains(RegExp(r'\d+')) // If contains any digits.
    ) ?? false;

    if (isNameIncorrect) {
      String _errorMsg = "Your name doesn't look right. Please try again.";
      setState(() => _errorText = _errorMsg);
    }
      else {
        // Remove any previous error messages.
        setState(() => _errorText = null);
    }
  }

  validateSelectedLevel(){
    if (selectedLevel == null) {
      showMessageDialog(
        context,
        msg: "Please select your level, then press next."
      );
      setState(() => isLevelValidationSuccess = false);
    }
    else setState(() => isLevelValidationSuccess = true);
  }

  saveInputtedData() {
    SharedPreferencesHelper.setName(_nameController.text);
    SharedPreferencesHelper.setLevel(selectedLevel);
  }

  void pushSubjectsPage() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) =>SubjectsSetup()));
  }
}

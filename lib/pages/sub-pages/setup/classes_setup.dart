import 'package:flutter/material.dart';

import '../../../util/shared_prefs_interface.dart';
import '../../../UI/setup_page.dart';
import 'recess_setup.dart';

class ClassesSetup extends StatefulWidget {
  @override
  _ClassesSetupState createState() => _ClassesSetupState();
}

class _ClassesSetupState extends State<ClassesSetup> {
  @override
  Widget build(BuildContext context) {
    return SetupPage(
      leadIcon: Icons.table_chart,
      title: "Classes",
      subtitle: "Set up your school classes/sessions info",
      body: _buildClassesBody(),
      onFloatingButtonPressed: pushRecessPage,
    );
  }

  Widget _buildClassesBody() =>ListView(
    children: <Widget>[
      ClassesLengthSlider(),
      NoOfClassesSlider(),
    ],
  );

  void pushRecessPage() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => RecessSetup()));
  }
}


/// Slider for setting the length of each user's class/session
class ClassesLengthSlider extends StatefulWidget {
  @override
  _ClassesLengthSliderState createState() => _ClassesLengthSliderState();
}

class _ClassesLengthSliderState extends State<ClassesLengthSlider> {
  String classesLength = "30.0";

  @override
  void initState() {
      super.initState();
      saveClassesLength(double.parse(classesLength));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10.0, top: 15.0),
          child: Text(
            "How long are the classes/sessions at your school?",
            textScaleFactor: 1.2,
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
        ),
        Center(
          child: Text(
            "$classesLength mins",
            textScaleFactor: 1.2,
            style: TextStyle(color: Colors.black45),
          )
        ),
        Slider(
          min: 15.0,
          max: 45.0,
          activeColor: Colors.deepPurpleAccent,
          inactiveColor: Colors.black54,
          divisions: 6,
          label: "$classesLength",
          value: double.parse(classesLength),
          onChanged: saveClassesLength,
        ),
      ],
    );
  }

  /// Updates the classes length in both the slider and in shared_prefs.
  void saveClassesLength(double length){
    String _length = "${length.toInt()}";

    SharedPreferencesHelper.setClassLength(_length);
    setState(() => classesLength = _length);
  }
}

/// Slider for setting the number of classes in a school day.
class NoOfClassesSlider extends StatefulWidget {
  @override
  _NoOfClassesSliderState createState() => _NoOfClassesSliderState();
}

class _NoOfClassesSliderState extends State<NoOfClassesSlider> {
  int noOfClasses = 8;

  @override
  void initState() {
    super.initState();
    saveNoOfClasses(noOfClasses.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 15.0, top: 15.0),
          child: Text(
            "How many classes/sessions do you have in a day? (Include any breaks/recesses as classes!)",
            textScaleFactor: 1.2,
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
        ),
        Center(
          child: Text(
            "$noOfClasses",
            textScaleFactor: 1.2,
            style: TextStyle(color: Colors.black45),
          )
        ),
        Slider(
          min: 6.0,
          max: 12.0,
          activeColor: Colors.deepPurpleAccent,
          inactiveColor: Colors.black54,
          divisions: 6,
          label: "$noOfClasses",
          value: noOfClasses.toDouble(),
          onChanged: saveNoOfClasses,
        ),
      ],
    );
  }

  /// Set the number of classes in both the slider and shared_prefs.
  void saveNoOfClasses(double no){
    SharedPreferencesHelper.setNoOfClasses(no.toInt());
    setState(() => noOfClasses = no.toInt());
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';

import 'past_paper_view.dart';
import '../../../UI/studento_app_bar.dart';


class PaperDetailsSelectionPage extends StatefulWidget {
  final String level;
  final String subjectName;
  PaperDetailsSelectionPage(this.subjectName, this.level);

  @override
  PaperDetailsSelectionPageState createState() =>
      PaperDetailsSelectionPageState();
}

class PaperDetailsSelectionPageState extends State<PaperDetailsSelectionPage> {
  static int minYear = 2008;
  int selectedYear = ((DateTime.now().year + minYear) / 2).round();
  int selectedComponent;
  final GlobalKey _menuKey = GlobalKey();
  /// This string is used so we know from which season a paper is.
  /// This can have two values: ["s"] and ["w"] because those are the file
  /// names for our papers. Example, 4024_s14_qp_12.html
  String selectedSeason;
  List<int> componentsList = [
    11,
    12,
    23,
    24,
  ];
  Map subjectCodesList;

  @override
  void initState() {
    super.initState();

    /// Load the json and decode it, then put it into [subjectCodesList].
    rootBundle
        .loadString('assets/json/subjects_syllabus_urls.json')
        .then((String fileData) {
      subjectCodesList = json.decode(fileData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StudentoAppBar(
        title: "Past Papers for ${widget.subjectName}",
        titleStyle: TextStyle(
          fontSize: 15.0,
          color: Colors.white,
        ),
      ),
      body: Container(child: _buildStepper()),
    );
  }

  /// Gets the subject code of the specified subject of the specified level.
  String _getSubjectCode(String level, String subject) {
    // TODO If past papers are unavailable for the subject, we should show
    // an AlertDialog and notify the user.
    return subjectCodesList["$level"][subject]['subject_code'];
  }

  void openPaper(String paperName) {
    Navigator
    .of(context)
    .push(MaterialPageRoute(builder: (BuildContext context) {
      return PastPaperView(paperName);
    }));
  }

  Stepper _buildStepper() {
    return Stepper(
      currentStep: currentStep,
      steps: buildSteps(),
      type: StepperType.vertical,
      // Update the variable handling the current step value and
      // jump to the tapped step.
      onStepTapped: (int step) => setState(() => currentStep = step),
      onStepCancel: () {
        // On hitting cancel button, change the state
        setState(() {
          // Update the variable handling the current step value
          // going back one step i.e subtracting 1, until its 0.
          if (currentStep > 0) {
            currentStep = currentStep - 1;
          } else {
            currentStep = 0;
          }
        });
      },
      // On hitting continue button, change the state.
      onStepContinue: () => handleOnStepContinue());
  }

  void handleOnStepContinue() {
    // Update the variable handling the current step value
    // going back one step i.e adding 1, until its the length of the
    // step.
    if (currentStep < buildSteps().length - 1) {
      setState(() => currentStep++);
    }
    // Check that all steps have been completed. If positive, send
    // the selected values off to WebView generator.
    else if (
      selectedComponent != null &&
      selectedYear != null &&
      selectedSeason != null)
      {
        String subjectCode = _getSubjectCode(widget.level, widget.subjectName);

        String paperName = "${subjectCode}_$selectedSeason" +
          selectedYear.toString().substring(2) +
          "_qp_" +
          selectedComponent.toString();

        openPaper("$paperName");
        print(
          "User selected year $selectedYear, season $selectedSeason and component $selectedComponent for the subject ${widget.subjectName} with componentcode $subjectCode");
        print("So the filename would be $paperName");
      } else {
        // Set the current step to the step which was not completed.
        // The uncompleted step has to be either Step 2 or 3 as year
        // already has a default value.
        setState(() => currentStep = (selectedSeason == null) ? 1 : 2);
    }
  }

  // Init the step to 0th position
  int currentStep = 0;

  List<Step> buildSteps() {
    List<Step> steps = [
      _buildYearSelectionStep(),
      _buildSeasonSelectionStep(),
      _buildComponentSelectionStep()
    ];
    return steps;
  }

  Step _buildYearSelectionStep() {
    /// Shows a dialog containing a [NumericalPicker] for the user to choose the
    /// year of the desired paper.
    void _showDialogToGetYear() {
      showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return NumberPickerDialog.integer(
            titlePadding: EdgeInsets.all(10.0),
            minValue: minYear,
            maxValue: DateTime.now().year,
            initialIntegerValue: selectedYear,
            title: Text(
              "Select year of the paper:",
              textAlign: TextAlign.center,
            ),
          );
        }
      ).then( (int pickedYear) {
        if (pickedYear != null) setState(() => selectedYear = pickedYear);
      });
    }

    Widget _content = Center(
      child: Column(
        children: <Widget>[
          Text("Choose the year of the paper you seek."),
          Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
          Divider(),
          ListTile(
            enabled: true,
            leading: Icon(Icons.date_range),
            onTap: _showDialogToGetYear,
            title: Text("Year"),
            trailing: Text(selectedYear.toString()),
          ),
          Divider(),
        ],
      )
    );

    return Step(
      title: Text("Year"),
      content: _content,
      isActive: (currentStep == 0) ? true : false,
    );
  }

  Step _buildSeasonSelectionStep() {
    void handleRadioChanged(String value) =>
      setState(() => selectedSeason = value);


    return Step(
      title: Text("Season"),
      isActive: (currentStep == 1) ? true : false,
      content: Column(
        children: <Widget>[
          RadioListTile(
            title: Text("Summer"),
            groupValue: selectedSeason,
            value: "s",
            onChanged: (String value) => handleRadioChanged(value),
          ),
          RadioListTile(
            title: Text("Winter"),
            groupValue: selectedSeason,
            value: "w",
            onChanged: (String value) => handleRadioChanged(value),
          ),
        ],
      ),
    );
  }

  Step _buildComponentSelectionStep() {
    List<PopupMenuItem<int>> components = [];

    void handlePopUpChanged(int value) =>
      setState(() => selectedComponent = value);

    // Add each component name into the list of PopupMenuItems, [components]
    // TODO use map function instead for this.
    for (int component in componentsList) {
      components.add(
        PopupMenuItem(
          child: Text("$component"),
          value: component,
        )
      );
    }

    return Step(
      title: Text("Component"),
      isActive: (currentStep == 2) ? true : false,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Select the component of the paper you seek.",
            textAlign: TextAlign.start,
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
          Divider(),
          ListTile(
            leading: Icon(Icons.blur_circular),
            title: Text("Component"),
            onTap: () {
              // When ListTile is tapped, open the popUpMenu!
              dynamic popUpMenustate = _menuKey.currentState;
              popUpMenustate.showButtonMenu();
            },
            trailing: PopupMenuButton(
              key: _menuKey,
              itemBuilder: (BuildContext context) => components,
              onSelected: handlePopUpChanged,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text((selectedComponent != null) ? selectedComponent.toString() : ''),
                  Icon(Icons.arrow_drop_down)
                ],
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}

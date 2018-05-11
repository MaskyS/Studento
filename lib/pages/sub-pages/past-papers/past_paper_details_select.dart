import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';
import 'past_paper_view.dart';

class PaperDetailsSelectionPage extends StatefulWidget {
  final String level;
  final String subjectName;
  PaperDetailsSelectionPage(this.subjectName, this.level);

  @override
  PaperDetailsSelectionPageState createState() =>
      new PaperDetailsSelectionPageState();
}

class PaperDetailsSelectionPageState extends State<PaperDetailsSelectionPage> {
  static int minYear = 2008;
  int selectedYear = ((DateTime.now().year + minYear) / 2).round();
  int selectedComponent;
  static String selectedSeason;
  List<int> componentsList = [
    11,
    12,
    23,
    24,
  ];
  final GlobalKey _menuKey = new GlobalKey();

  Map subjectCodesList;

  /// Gets the subject code of the specified subject of the specified level.
  String _getSubjectCode(String level, String subject) {
    return subjectCodesList["$level level"][subject]['subject_code'];
  }

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

  void openPaper(url) {
    url = "9706_w14_qp_23";
    Navigator
        .of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) {
      return new PastPaperView(url);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: new Text(
          "Past Papers for ${widget.subjectName}",
          textScaleFactor: 0.8,
        ),
      ),
      body: //new Center(child: new RaisedButton(
          //   onPressed: () => openPaper(''),
          //   child: new Text("Open Webview"),
          //   color: Colors.blue[700],
          //   )
          // )
          new Container(
        child: _buildStepper(),
      ),
    );
  }

  Stepper _buildStepper() {
    return new Stepper(
        currentStep: currentStep,
        steps: buildSteps(),
        type: StepperType.vertical,
        onStepTapped: (step) {
          // On hitting step itself, change the state and jump to that step.
          setState(() {
            // Update the variable handling the current step value
            // jump to the tapped step.
            currentStep = step;
          });
        },
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
      setState(() {
        currentStep++;
      });
    }
    // Check that all steps have been completed. If positive, send
    // the selected values off to WebView generator.
    else if (selectedComponent != null &&
        selectedYear != null &&
        selectedSeason != null) {
      String subjectCode = _getSubjectCode(widget.level, widget.subjectName);
      String paperName = subjectCode +
          "_" +
          selectedSeason +
          selectedYear.toString().substring(2) +
          "_qp_" +
          selectedComponent.toString();
      print(
          "User selected year $selectedYear, season $selectedSeason and component $selectedComponent for the subject ${widget.subjectName} with componentcode $subjectCode");
      print("So the filename would be $paperName");
      openPaper('url');
    } else {
      // Set the current step to the step which was not completed.
      // The uncompleted step has to be either Step 2 or 3 as year
      // already has a default value.
      setState(() {
        currentStep = (selectedSeason == null) ? 1 : 2;
      });
    }
  }

  // Init the step to 0th position
  int currentStep = 0;

  List<Step> buildSteps() {
    List<Step> steps = [
      _buildYearSelectionStep(),
      _buildSeasonSelectionStep(),
      _buildPaperSelectionStep()
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
            return new NumberPickerDialog.integer(
              titlePadding: const EdgeInsets.all(10.0),
              minValue: minYear,
              maxValue: new DateTime.now().year,
              initialIntegerValue: selectedYear,
              title: new Text(
                "Select year of the paper:",
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w400),
              ),
            );
          }).then((int pickedYear) {
        if (pickedYear != null) {
          setState(() => selectedYear = pickedYear);
        }
      });
    }

    Widget _content = new Center(
        child: new Column(
      children: <Widget>[
        new Text("Choose the year of the paper you seek."),
        new Padding(
          padding: new EdgeInsets.symmetric(vertical: 10.0),
        ),
        new Divider(),
        new ListTile(
          enabled: true,
          leading: new Icon(Icons.date_range),
          onTap: _showDialogToGetYear,
          title: new Text("Year"),
          trailing: new Text(selectedYear.toString()),
        ),
        new Divider(),
      ],
    ));

    return new Step(
      title: new Text("Year"),
      content: _content,
      isActive: (currentStep == 0) ? true : false,
    );
  }

  Step _buildSeasonSelectionStep() {
    void handleRadioChanged(String value) {
      setState(() {
        selectedSeason = value;
      });
    }

    return new Step(
      title: new Text("Season"),
      isActive: (currentStep == 1) ? true : false,
      content: new Column(
        children: <Widget>[
          new RadioListTile(
            title: new Text("Summer"),
            groupValue: selectedSeason,
            value: "s",
            activeColor: Colors.blue[700],
            onChanged: (String value) => handleRadioChanged(value),
          ),
          new RadioListTile(
            title: new Text("Winter"),
            groupValue: selectedSeason,
            value: "w",
            activeColor: Colors.blue[700],
            onChanged: (String value) => handleRadioChanged(value),
          ),
        ],
      ),
    );
  }

  Step _buildPaperSelectionStep() {
    List<PopupMenuItem> components = [];

    void handlePopUpChanged(int value) {
      setState(() {
        selectedComponent = value;
      });
    }

    // Add each component name into the list of PopupMenuItems, [components]
    for (int component in componentsList) {
      components.add(new PopupMenuItem(
        child: new Text("$component"),
        value: component,
      ));
    }

    return new Step(
      title: new Text("Component"),
      isActive: (currentStep == 2) ? true : false,
      content: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Center(
              child: new Text("Select the component of the paper you seek.")),
          new Padding(
            padding: new EdgeInsets.symmetric(vertical: 10.0),
          ),
          new Divider(),
          new ListTile(
            leading: new Icon(Icons.blur_circular),
            title: new Text("Component"),
            onTap: () {
              // When ListTile is tapped, open the popUpMenu!
              dynamic popUpMenustate = _menuKey.currentState;
              popUpMenustate.showButtonMenu();
            },
            trailing: new PopupMenuButton(
              key: _menuKey,
              onSelected: (selectedDropDownItem) =>
                  handlePopUpChanged(selectedDropDownItem),
              itemBuilder: (BuildContext context) => components,
              child: new Row(
                children: <Widget>[
                  new Text(
                    (selectedComponent != null)
                        ? selectedComponent.toString()
                        : '...',
                  ),
                  new Icon(
                    Icons.arrow_drop_down,
                  ),
                ],
              ),
            ),
          ),
          new Divider(),
        ],
      ),
    );
  }
}

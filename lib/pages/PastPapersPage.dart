import 'package:flutter/material.dart';
import '../UI/StudentoAppBar.dart';
import 'dart:async';

// Boilerplate.
class AlertDialogMarksSlider extends StatefulWidget {
  @override
  _AlertDialogMarksSliderState createState() => new _AlertDialogMarksSliderState();
}

/// This widget contains the Slider that lives within the AlertDialog that
/// appears when the "Mark as completed" button is pressed.
///  We needed to put the AlertDialog's slider in a separate Stateful Widget
/// because otherwise, when the slider is dragged it would not move despite
/// the value being updated. (i.e, the slider was not being rebuilt)
class _AlertDialogMarksSliderState extends State<AlertDialogMarksSlider>{
 static int _marks = 0;

  Widget build(BuildContext context){
    return new Slider(
      value: _marks.toDouble(),
      min: 0.0,
      max: 100.0,
      divisions: 100,
      label: _marks.toString(),
      onChanged: (double value) {setState(() {
        // When the slider is moved/changed, we assign the new value of the
        // slider to the _marks variable. Later, we'll get the marks from here
        // in PastPapersPageState.
        _marks = value.floor();
      }); },
    );
  }

}

// Boilerplate
class PastPapersPage extends StatefulWidget {
  static String routeName = "past_papers_page";
  @override
  _PastPapersPageState createState() => new _PastPapersPageState();

}

class _PastPapersPageState extends State<PastPapersPage> {
  bool _isCompleted = false;
  Color _colorOfMarkAsCompleteButton;
  static int _marks = 0;

  Future<Null> _showDialogToGetMarks() async {

    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Enter your marks for this paper:'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: new AlertDialogMarksSlider(),
                ),
                // Corny quote to remind the user to not compare marks with his
                // peers.
                new Text("Comparison is the death of joy.\n   - Mark Twain",
                  textScaleFactor: 0.8,
                  style: new TextStyle(fontStyle: FontStyle.italic,)
                ),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Enter'),
              onPressed: () {
                setState(() {
                  // When the Enter button is pressed, we get the value of the
                  // slider and store it.
                  _marks =  _AlertDialogMarksSliderState._marks;
                });
                // Close the dialog.
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _pressedMarkAsCompleteButton() {
    // If button has been pressed before, we reset the color to white.
    // Else, we set the color of the icon to lime, and show the dialog so we
    // can get the marks the user has scored for this paper.
    setState(() {
      if (_isCompleted){
        _colorOfMarkAsCompleteButton = Colors.white;
        _isCompleted= false;
      }
      else{
         _colorOfMarkAsCompleteButton = Colors.limeAccent[700];
        _isCompleted = true;
        _showDialogToGetMarks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions;
    actions = [
      new IconButton(
        icon: const Icon(Icons.beenhere),
        onPressed: _pressedMarkAsCompleteButton,
        color: _colorOfMarkAsCompleteButton,
        tooltip: "Mark this paper as completed.",
      ),
    ];

    // If "Marked as complete" button is pressed,
    // display the marks.
    if (_isCompleted){
      actions.add(
        // Wrap the button in a SizedBox so as to reduce its size.
        new SizedBox(
          height: 1.0,
          width: 45.0,
          child: new FlatButton(
            padding: EdgeInsets.all(5.0),
            onPressed: () {_showDialogToGetMarks();},
            child: new Center(
              child: new Text(
                _marks.round().toString(),
                style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0,),
              ),
            ),
            splashColor: Colors.deepPurpleAccent[400],
            textColor: Colors.white,
          ),
        ),
      );
    }
    //If the paper had been marked as completed and is now being unmarked,
    // remove the marks from the AppBar.
    else if (actions.length == 2){
      actions.removeLast();
    }

    return new Scaffold(
      appBar: new StudentoAppBar(
        actions: actions,
      ),

      body: new Container(
        child: new Text('Hello!  This PastPapersPage isn\'t ready for your eyes yet :)'),
      ),
    );
  }
}
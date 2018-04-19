import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../UI/StudentoAppBar.dart';
import '../UI/StudentoDrawer.dart';
import 'dart:async';

const double _kPickerSheetHeight = 216.0;

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
  bool _isFullScreen = true;
  Color _colorOfMarkAsCompleteButton;
  IconData _iconOfFullScreenButton = Icons.fullscreen;
  DateTime minYear = DateTime(2005);
  DateTime selectedYear = DateTime.now();
  int _selectedItemIndex = 0;
  List<String> subjectsList = ["French", "Maths", "English", "Additional Mathematics", "Chemistry", "Physics", "Biology", "Literature"];

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
                new Text("Comparison is the death of joy.\n     - Mark Twain",
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

  /// Shows a dialog that contains a datePicker. TODO Improve selection so that
  /// when user selects the year, the dialog is closed immediately instead of
  /// displaying the month/day picker. This will probably require some custom
  /// Widget that will show a dialog containing the YearPicker widget.
  Future<Null> _showDialogToGetYear() async {
    DateTime picked = await showDatePicker(
      context: context,
      firstDate: minYear,
      lastDate: new DateTime.now(),
      initialDate: selectedYear,
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null) setState(() {
      selectedYear = picked;
      print(selectedYear.year);
    });
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

  void _pressedFullScreenButton() {
    setState((){
      if (_isFullScreen){
        //  TODO implement setFullscreen() method
        _iconOfFullScreenButton = Icons.fullscreen_exit;
        _isFullScreen = false;
      }
      else {
        _iconOfFullScreenButton = Icons.fullscreen;
        _isFullScreen = true;
      }
    }
    );}
  Widget _buildCupertinoPicker(List<String> items){
    final FixedExtentScrollController scrollController = new FixedExtentScrollController(initialItem: _selectedItemIndex);
    return new Container(
      height: _kPickerSheetHeight,
      child: new GestureDetector(
        onTap: () {},
        child: new SafeArea(
          child: new CupertinoPicker(
            backgroundColor: Colors.white,
            itemExtent: 32.0,
            scrollController: scrollController,
            children: new List<Widget>.generate(items.length, (int index) {
              return new Center(child: new Text(items[index]),);
            }),
            onSelectedItemChanged: (int index) {
              setState(() {
                _selectedItemIndex = index;
              });
            }
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceListTile(String title, IconData icon, List<String> items){
    return new ListTile(
      enabled: true,
      leading: new Icon(icon),
      onTap: () async {
        await showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context){
            return _buildCupertinoPicker(items);
          },
        );
      },
      title: new Text(title),
      trailing: new Text("${items[_selectedItemIndex]}"),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions;
    actions = [
      new SizedBox(
        height: 24.0,
        width: 30.0,
        child: new IconButton(
          icon: new Icon(_iconOfFullScreenButton),
          iconSize: 22.0,
          padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 0.0, right: 50.0),
          onPressed: _pressedFullScreenButton,
          color: Colors.white,
          tooltip: "Set full screen.",
        ),
      ),
      new SizedBox(
        height: 25.0,
        width: 30.0,
        child: new IconButton(
          icon: const Icon(Icons.beenhere),
          iconSize: 18.0,
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
          onPressed: _pressedMarkAsCompleteButton,
          color: _colorOfMarkAsCompleteButton,
          tooltip: "Mark this paper as completed.",
        ),
      ),
    ];

    // If "Marked as complete" button is pressed,
    // display the marks.
    if (_isCompleted){
      actions.add(
        // Wrap the button in a SizedBox so as to reduce its size.
        new SizedBox(
          height: 1.0,
          width: 35.0,
          child: new FlatButton(
            shape: new CircleBorder(side: const BorderSide(color: Colors.white, )),
            padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
            onPressed: () {_showDialogToGetMarks();},
            child: new Center(
              child: new Text(
                _marks.round().toString(),
                style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5,),
              ),
            ),
            splashColor: Colors.deepPurpleAccent[400],
            textColor: Colors.white,
          ),
        ),
      );
    }
    // If the paper had been marked as completed and is now being unmarked,
    // remove the marks from the AppBar.
    else if (actions.length == 3){
      actions.removeLast();
    }


    return new Scaffold(
      appBar: new StudentoAppBar(
        actions: actions,
      ),
      drawer: new StudentoDrawer(),

      body:
      new Column(
        children: <Widget>[
          new Divider(color: Colors.white),
          new ListTile(
            enabled: true,
            leading: new Icon(Icons.date_range),
            onTap: _showDialogToGetYear,
            title: new Text("Year"),
            trailing: new Text(selectedYear.year.toString()),
          ),
          new Divider(),
          _buildChoiceListTile('Subject', Icons.subject, subjectsList),
          new FlatButton(
            child: new Text("Go!"),
            onPressed: () {print("This will launch the WebView, once that is implemented.");},
            padding: const EdgeInsets.all(22.0),
            shape: new CircleBorder(side: const BorderSide(color: Colors.deepPurple),),
            splashColor: Colors.deepPurpleAccent,
          ),
        ],
      ),
    );
  }

}
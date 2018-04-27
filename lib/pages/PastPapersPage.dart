import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../UI/StudentoAppBar.dart';
import '../UI/StudentoDrawer.dart';
import 'package:numberpicker/numberpicker.dart';


const double _kPickerSheetHeight = 216.0;

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
  static int minYear = 2005;
  int selectedYear = ((DateTime.now().year + minYear) / 2).round();
  int _selectedItemIndex = 0;
  List<String> subjectsList = ["French", "Maths", "English", "Additional Mathematics", "Chemistry", "Physics", "Biology", "Literature"];

  static int _marks = 0;
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
            onPressed: () => _showDialogToGetMarks(),
            splashColor: Colors.deepPurpleAccent[400],
            textColor: Colors.white,
            child: new Center(
              child: new Text(
                _marks.round().toString(),
                style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5,),
              ),
            ),
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
      appBar: new StudentoAppBar(actions: actions,),
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
            trailing: new Text(selectedYear.toString()),
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

  /// Shows a dialog for user to choose the marks of the displayed paper.
  Future<int> _showDialogToGetMarks() async {
    return showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new NumberPickerDialog.integer(
          title: new Text("Enter your marks for this paper:",
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
          titlePadding: const EdgeInsets.all(10.0),
          minValue: 0,
          maxValue: 100,
          initialIntegerValue: _marks,
        );
      }
    ).then((int pickedValue){
      if (pickedValue != null){
        setState(() => _marks = pickedValue);
      }
    });
  }

  /// Shows a dialog for user to choose the year of the desired paper.
  Future<Null> _showDialogToGetYear() async {
    return showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new NumberPickerDialog.integer(
          title: new Text("Select year of the paper:",
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
          titlePadding: const EdgeInsets.all(10.0),
          minValue: minYear,
          maxValue: new DateTime.now().year,
          initialIntegerValue: selectedYear,
        );
      }
    ).then((int pickedValue){
      if (pickedValue != null){
        setState(() => selectedYear = pickedValue);
      }
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
    );
  }

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

}
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class PastPaperView extends StatefulWidget {
  final String paperName;
  PastPaperView(this.paperName);
  @override
  _PastPaperViewState createState() => new _PastPaperViewState();
}

class _PastPaperViewState extends State<PastPaperView> {
  bool _isCompleted = false;
  bool _isFullScreen = true;
  Color _colorOfMarkAsCompleteButton;
  IconData _iconOfFullScreenButton = Icons.fullscreen;
  static int minYear = 2008;
  int selectedYear = ((DateTime.now().year + minYear) / 2).round();
  static int _marks = 0;


  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print("Path is $path");
    return new File('$path/text.html');
  }

  void readHtml() async {
    bool res = await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
    print("permission request result is " + res.toString());
    try {
      final file = await _localFile;
      String contents = file.readAsStringSync();
      setState(() {
        html = contents;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  String html;

  @override
  void initState() {
    // readHtml().then((String contents){
    //   setState(() {
    //     html = contents;
    //   });
    // });
    // rootBundle.loadString('assets/text.html').then((String fileData){
    //   html= fileData;
    // });
    readHtml();
    super.initState();
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

    // If the paper had been marked as completed and is now being unmarked,
    // remove the marks from the AppBar.
    if (!_isCompleted){
      actions.removeLast();
    }
    // If "Marked as complete" button is pressed, display the marks.
    else if (actions.length == 3){
      actions.add(
        // Wrap the button in a SizedBox so as to reduce its size.
        new SizedBox(
          height: 1.0,
          width: 35.0,
          child: new FlatButton(
            shape: new CircleBorder(side: const BorderSide(color: Colors.white, )),
            padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
            onPressed: _showDialogToGetMarks,
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

    if (html == null){
      return new CircularProgressIndicator();
    }

    return new WebviewScaffold(
      // TODO fix assets loading.
      url: new Uri.dataFromString(html, mimeType: 'text/html', parameters: { 'charset': 'utf-8' }).toString(),
      appBar: new AppBar(
        title: new Text("Widget webview"),
      ),
      withZoom: true,
      withLocalStorage: true,
    );
  }


  /// Shows a dialog for user to choose the marks of the displayed paper.
  void _showDialogToGetMarks() {
    showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new NumberPickerDialog.integer(
          titlePadding: const EdgeInsets.all(10.0),
          minValue: 0,
          maxValue: 100,
          initialIntegerValue: _marks,
          title: new Text("Enter your marks for this paper:",
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
        );
      }
    ).then((int pickedValue){
      if (pickedValue != null){
        setState(() => _marks = pickedValue);
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
    });
  }

}
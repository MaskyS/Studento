// import 'dart:io';
// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:simple_permissions/simple_permissions.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import '../../../UI/studento_app_bar.dart';
import '../../../util/jaguar_laucher.dart';

class PastPaperView extends StatefulWidget {
  final String paperName;
  PastPaperView(this.paperName);
  @override
  _PastPaperViewState createState() => _PastPaperViewState();
}

class _PastPaperViewState extends State<PastPaperView> {
  bool _isCompleted;
  bool _isFullScreen = true;
  Color _colorOfMarkAsCompleteButton = Colors.white;
  IconData _iconOfFullScreenButton = Icons.fullscreen;
  List<Widget> actions;
  static int minYear = 2008;
  int selectedYear = ((DateTime.now().year + minYear) / 2).round();
  static int _marks = 0;

  // Future<String> get _localPath async {
  //   final directory = await getExternalStorageDirectory();
  //   return directory.path;
  // }

  // Future<File> get _localFile async {
  //   final path = await _localPath;
  //   print("Path is $path");
  //   return new File('$path/text.html');
  // }

  // void readHtml() async {
  //   bool res = await SimplePermissions
  //       .requestPermission(Permission.WriteExternalStorage);
  //   print("permission request result is " + res.toString());
  //   try {
  //     final file = await _localFile;
  //     String contents = file.readAsStringSync();
  //     setState(() {
  //       html = contents;
  //     });
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  // String html;

  @override
  void initState() {
    super.initState();
    actions = getActions();
    JaguarLauncher.startLocalServer(serverRoot: 'past-papers');
    // readHtml().then((String contents){
    //   setState(() {
    //     html = contents;
    //   });
    // });
    // rootBundle.loadString('assets/text.html').then((String fileData){
    //   html= fileData;
    // });

//    readHtml();
  }

  @override
  Widget build(BuildContext context) {
    actions = getActions();

    if (_isCompleted == true){
      actions.add(
        // Wrap the button in a SizedBox so as to reduce its size.
        SizedBox(
          height: 1.0,
          width: 35.0,
          child: FlatButton(
            shape: CircleBorder(
                side: const BorderSide(
              color: Colors.white,
            )),
            padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
            onPressed: _showDialogToGetMarks,
            splashColor: Colors.deepPurpleAccent[400],
            textColor: Colors.white,
            child: Center(
              child:Text(
                _marks.round().toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.5,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return new WebviewScaffold(
      url: "http://localhost:8080/${widget.paperName}.html",
      // url: new Uri.dataFromString(html,
      //     mimeType: 'text/html', parameters: {'charset': 'utf-8'}).toString(),
      appBar: StudentoAppBar(
        title: Text("View Paper"),
        actions: actions,
      ),
    );
  }

  List<Widget> getActions() {
    actions = [
      SizedBox(
        height: 25.0,
        width: 30.0,
        child: IconButton(
          icon: const Icon(Icons.check_circle),
          iconSize: 18.0,
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
          onPressed: _pressedMarkAsCompleteButton,
          color: _colorOfMarkAsCompleteButton,
          tooltip: "Mark this paper as completed.",
        ),
      ),
      SizedBox(
        height: 24.0,
        width: 30.0,
        child: IconButton(
          icon: Icon(_iconOfFullScreenButton),
          iconSize: 22.0,
          padding:
              EdgeInsets.only(top: 8.0, bottom: 8.0, left: 0.0, right: 50.0),
          onPressed: _pressedFullScreenButton,
          color: Colors.white,
          tooltip: "Set full screen.",
        ),
      ),
    ];
    return actions;
  }

  /// Shows a dialog for user to choose the marks of the displayed paper.
  void _showDialogToGetMarks() {
    showDialog<int>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return NumberPickerDialog.integer(
            titlePadding: const EdgeInsets.all(10.0),
            minValue: 0,
            maxValue: 100,
            initialIntegerValue: _marks,
            title: Text(
              "Enter your marks for this paper:",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
          );
        }
    ).then((int pickedValue) {
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
      if (_isCompleted == true) {
        _colorOfMarkAsCompleteButton = Colors.white;
        _isCompleted = false;
      } else {
        _colorOfMarkAsCompleteButton = Colors.limeAccent[700];
        _isCompleted = true;
        _showDialogToGetMarks();
      }
    });
  }

  void _pressedFullScreenButton() {
    setState(() {
      if (_isFullScreen) {
        //  TODO implement setFullscreen() method
        _iconOfFullScreenButton = Icons.fullscreen_exit;
        _isFullScreen = false;
      } else {
        _iconOfFullScreenButton = Icons.fullscreen;
        _isFullScreen = true;
      }
    });
  }
}

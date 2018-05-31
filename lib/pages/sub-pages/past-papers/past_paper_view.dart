// import 'dart:io';
// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
// import 'package:path_provider/path_provider.dart';
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
  Color _colorOfMarkAsCompleteButton = Colors.white;
  List<Widget> actions;
  static int minYear = 2008;
  int selectedYear = ((DateTime.now().year + minYear) / 2).round();
  static int _marks = 0;
  String subjectCode;


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
    JaguarLauncher.startLocalServer();
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
    subjectCode = widget.paperName.substring(0,4);

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

    return WebviewScaffold(
      url: "http://localhost:8080/html/past-papers/$subjectCode/${widget.paperName}.html",
      withLocalUrl: true,
      withZoom: true,
      withJavascript: true,
      // url: new Uri.dataFromString(html,
      //     mimeType: 'text/html', parameters: {'charset': 'utf-8'}).toString(),
      appBar: StudentoAppBar(
        title: "View Paper",
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
          icon: Icon(Icons.check_circle),
          iconSize: 18.0,
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
          onPressed: _pressedMarkAsCompleteButton,
          color: _colorOfMarkAsCompleteButton,
          tooltip: "Mark this paper as completed.",
        ),
      ),
      SizedBox(
        height: 25.0,
        width: 30.0,
        child: IconButton(
          icon: Text("MS"),
          iconSize: 22.0,
          padding:
              EdgeInsets.only(top: 8.0, bottom: 8.0, left: 0.0, right: 50.0),
          onPressed: _pressedMarkingSchemeButton,
          color: Colors.white,
          tooltip: "View Marking Scheme",
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
        Navigator.of(context).pop();
        _showDialogToGetMarks();
      }
    });
  }

  void _pressedMarkingSchemeButton() {
    var msFileName = widget.paperName.replaceFirst('_qp_', '_ms_');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => new WebviewScaffold(
          url: "http://localhost:8080/html/past-papers/$subjectCode/$msFileName.html",
        ),
      ),
    );
  }
}

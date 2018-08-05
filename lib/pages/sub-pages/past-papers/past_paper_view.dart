/// The only reason to keep this class is for the code for the AppBar, and for storing the various marks for the subjects.

// import 'package:flutter/material.dart';

// import 'package:numberpicker/numberpicker.dart';
// import 'package:flutter_pdf_viewer/flutter_pdf_viewer.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

// import '../../../UI/studento_app_bar.dart';

// class PastPaperView extends StatefulWidget {
//   final String paperName;
//   PastPaperView(this.paperName);
//   @override
//   _PastPaperViewState createState() => _PastPaperViewState();
// }

// class _PastPaperViewState extends State<PastPaperView> {
//   bool _isCompleted;
//   Color _colorOfMarkAsCompleteButton = Colors.white;
//   List<Widget> actions;
//   static int minYear = 2008;
//   int selectedYear = ((DateTime.now().year + minYear) / 2).round();
//   static int _marks = 0;
//   String subjectCode;

//   @override
//   void initState() {
//     super.initState();
//     actions = getActions();
//   }

//   void loadPastPaper() {
//     String fileUri = "assets/pdf/past-papers/$subjectCode/$selectedYear/${widget.paperName}.html";
//      FlutterPdfViewer.loadAsset(fileUri);
//   }

//   @override
//   Widget build(BuildContext context) {
//     actions = getActions();
//     subjectCode = widget.paperName.substring(0,4);

//     if (_isCompleted == true){
//       actions.add(
//         // Wrap the button in a SizedBox so as to reduce its size.
//         SizedBox(
//           height: 1.0,
//           width: 35.0,
//           child: FlatButton(
//             shape: CircleBorder(
//                 side: const BorderSide(
//               color: Colors.white,
//             )),
//             padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
//             onPressed: _showDialogToGetMarks,
//             splashColor: Colors.deepPurpleAccent[400],
//             textColor: Colors.white,
//             child: Center(
//               child:Text(
//                 _marks.round().toString(),
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 13.5,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
//     }

//     return Center(child: Text("Hi, this worked perfectly."));
//   }

//   List<Widget> getActions() {
//     actions = [
//       SizedBox(
//         height: 25.0,
//         width: 40.0,
//         child: IconButton(
//           icon: Icon(Icons.check_circle),
//           iconSize: 20.0,
//           padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
//           onPressed: _pressedMarkAsCompleteButton,
//           color: _colorOfMarkAsCompleteButton,
//           tooltip: "Mark this paper as completed.",
//         ),
//       ),
//       SizedBox(
//         height: 25.0,
//         width: 40.0,
//         child: IconButton(
//           icon: Text(
//             "MS",
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           iconSize: 25.0,
//           padding:
//               EdgeInsets.symmetric(vertical: 8.0),
//           onPressed: _pressedMarkingSchemeButton,
//           color: Colors.white,
//           tooltip: "View Marking Scheme",
//         ),
//       ),
//     ];
//     return actions;
//   }

//   /// Shows a dialog for user to choose the marks of the displayed paper.
//   void _showDialogToGetMarks() {
//     showDialog<int>(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return NumberPickerDialog.integer(
//             titlePadding: const EdgeInsets.all(10.0),
//             minValue: 0,
//             maxValue: 100,
//             initialIntegerValue: _marks,
//             title: Text(
//               "Enter your marks for this paper:",
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontWeight: FontWeight.w400),
//             ),
//           );
//         }
//     ).then((int pickedValue) {
//       if (pickedValue != null){
//         setState(() => _marks = pickedValue);
//       }
//     });
//   }

//   void _pressedMarkAsCompleteButton() {
//     // If button has been pressed before, we reset the color to white.
//     // Else, we set the color of the icon to lime, and show the dialog so we
//     // can get the marks the user has scored for this paper.
//     setState(() {
//       if (_isCompleted == true) {
//         _colorOfMarkAsCompleteButton = Colors.white;
//         _isCompleted = false;
//       } else {
//         _colorOfMarkAsCompleteButton = Colors.limeAccent[700];
//         _isCompleted = true;
//         Navigator.of(context).pop();
//         _showDialogToGetMarks();
//       }
//     });
//   }

//   void _pressedMarkingSchemeButton() {
//     var msFileName = widget.paperName.replaceFirst('_qp_', '_ms_');

//     Widget markingSchemeActionButton = SizedBox(
//       height: 25.0,
//       width: 40.0,
//       child: IconButton(
//         iconSize: 25.0,
//         color: Colors.white,
//         tooltip: "View Marking Scheme",
//         padding: EdgeInsets.symmetric(vertical: 8.0),
//         onPressed: () => Navigator.of(context).pop(),
//         icon: Text(
//           "QP",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (_) => WebviewScaffold(
//           url: "http://localhost:8080/html/past-papers/$subjectCode/$msFileName.html",
//           appBar: StudentoAppBar(
//             title: "View marking scheme",
//             actions: <Widget>[markingSchemeActionButton],
//           ),
//         ),
//       ),
//     );
//   }
// }

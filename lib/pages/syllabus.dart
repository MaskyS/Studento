import 'package:flutter/material.dart';
import '../UI/studento_app_bar.dart';
import '../UI/studento_drawer.dart';
import '../UI/subjects_staggered_grid_view.dart';
import 'package:connectivity/connectivity.dart';

class SyllabusPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SyllabusPageState();
  }
}

class SyllabusPageState extends State<SyllabusPage> {
  @override
  void initState() {
    super.initState();
    checkifConnected();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new StudentoDrawer(),
      body: new SubjectsStaggeredListView('syllabusPage'),
      appBar: new StudentoAppBar(
        title: new Text("Syllabus"),
      ),
    );
  }

  /// In this free version of Studento, syllabus are only available online.
  /// To prevent any nasty errors, we check if the device is connnected
  /// beforehand, and display an [AlertDialog] if we're offline.
  ///
  /// One thing to note is that if the user is connected to a mobile hotspot
  /// without internet connection, this method is not going to work.
  void checkifConnected() async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(20.0),
              title: Text("Connection error"),
              content: Text(
                  "Accessing syllabus requires an internet connection. Please connect to the internet and try again."),
              actions: <Widget>[
                FlatButton(
                  child: new Text("OK"),
                  onPressed: () =>
                      Navigator.of(context).popUntil(ModalRoute.withName('/')),
                )
              ],
            );
          });
    }
  }
}

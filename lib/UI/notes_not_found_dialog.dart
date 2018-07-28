import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class NotesNotFoundAlertDialog extends StatelessWidget {

  Future launchGithubIssuesPage() async {
    const url = "https://github.com/MaskyS/studento/issues/";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not open issues page. Check your internet connection and try again.";
    }
  }

  List<Widget> buildActionButtons(BuildContext context) => <Widget>[
    FlatButton(
      child: Text('FILE ISSUE'),
      onPressed: launchGithubIssuesPage,
    ),
    FlatButton(
      child: Text('OK'),
      onPressed: () => Navigator.of(context).popUntil(
          ModalRoute.withName('home_page')), // Return to HomePage.
    )
  ];

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text('Sorry!'),
      actions: buildActionButtons(context),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 12.0)),
            Text('''No notes for this topic or subject :(
\nThe good news is that you can request for it by filing an issue.'''),
          ],
        ),
      ),
    );
  }
}
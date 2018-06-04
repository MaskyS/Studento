import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';

class RateDialog extends StatelessWidget {
  BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    buildContext = context;

    return AlertDialog (
      contentPadding:  EdgeInsets.all(0.0),
      content: Column (
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          Container (
            color: Color(0xFF5fbff9),
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: Center (
              child: Icon(Icons.shop, color: Colors.white, size: 48.0),
            ),
          ),
          Container (
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Text(
              'Rate the app?',
              style: TextStyle (
                color: Colors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container (
            margin: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Text('You are one of the first people to download Studento, and your feedback is very important.\n\nWould you mind giving it a rating on the Play Store?'),
          ),
          Container (
            margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0, bottom: 16.0),
            child: Row (
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget> [
                Icon(Icons.star_border),
                Icon(Icons.star_border),
                Icon(Icons.star_border),
                Icon(Icons.star_border),
                Icon(Icons.star_border),
              ],
            ),
          ),
        ],
      ),
      actions: <Widget> [
        FlatButton (
          child: Text('NEVER ASK AGAIN'),
          textColor: Colors.black38,
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton (
          child: Text('RATE IT'),
          onPressed: () {
            LaunchReview.launch(androidAppId: 'com.MaskyS.studento');
            showRatedDialog();
          },
        ),
      ],
    );
  }

  void showRatedDialog() {
    showDialog (
      barrierDismissible: false,
      context: buildContext,
      builder: (_) => AlertDialog(
        titlePadding: EdgeInsets.symmetric(vertical: 32.0),
        title: Container(
          color: Color(0xFFfc6dab),
          alignment: Alignment.center,
          child: Icon(
            Icons.favorite,
            color: Colors.white,
            size: 48.0,
          ),
        ),

        content: Text("Thank you, you are the absolute best."),
        actions: <Widget>[
          FlatButton(
            child: Text("YOU BET I AM!"),
            onPressed: () {
              Navigator.of(buildContext).pop();
              Navigator.of(buildContext).pop();
            },
          ),
        ],
      ),
    );
  }
}
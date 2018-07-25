import 'dart:async';
import 'package:flutter/material.dart';
import '../util/shared_prefs_interface.dart';

class TimeTextWidget extends StatefulWidget {
  TimeTextWidget({Key key}) : super(key: key);

  @override
  _TimeTextWidgetState createState() => _TimeTextWidgetState();
}

/// This class holds the UI and the logic for the Time and the greeting text
/// you see on the Home Page.
class _TimeTextWidgetState extends State<TimeTextWidget> {
  Timer _timer;
  DateTime _time;
  String userName;

  getUserName() async{
    String _userName = await SharedPreferencesHelper.getName();
    setState(() => userName = _userName);
  }

  @override
  void initState() {
    super.initState();
    getUserName();
    _time = DateTime.now();

    const duration =
        Duration(milliseconds: Duration.millisecondsPerSecond ~/ 4);
    _timer = Timer.periodic(duration, _updateTime);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime(Timer _) {
    setState(() =>
      _time = DateTime.now()
    );
  }

  // Say good morning, afternoon or evening as suitable.
  String __getProperGreeting() {
    String greeting;
    String timePeriod;
    final int currentHour = DateTime.now().hour;

    if (currentHour > 2 && currentHour < 12) {
      timePeriod = "Morning";
    } else if (currentHour < 17) {
      timePeriod = "Afternoon";
    } else {
      timePeriod = "Evening";
    }

    greeting = "Good $timePeriod, $userName.";
    return greeting;
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int d) {
      if (d < 10) return '0$d';
      return d.toString();
    }

    String formatTime(date) {
      return '${twoDigits(date.hour)}:${twoDigits(date.minute)}';
    }

    final Color studentoWhite = Color(0xFFfafafa);
    final String time = formatTime(_time);
    final String _greeting = __getProperGreeting();

    Text _greetingWidget = Text(
      _greeting,
      style: TextStyle(
        fontSize: 16.0,
        color: studentoWhite
      ),
    );

    Text _timeWidget = Text(
      time,
      style: TextStyle(
        fontSize: 60.0,
        fontWeight: FontWeight.w800,
        color: studentoWhite,
        fontStyle: FontStyle.italic,
      ),
    );

    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      margin: EdgeInsets.only(top: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _timeWidget,
          _greetingWidget,
        ],
      ),
    );
  }
}

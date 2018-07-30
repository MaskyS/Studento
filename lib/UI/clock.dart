import 'dart:async';
import 'package:flutter/material.dart';
import '../util/shared_prefs_interface.dart';

/// This class holds the UI and the logic for the Time and the greeting text
/// you see on the Home Page.
class Clock extends StatefulWidget {
  Clock({Key key}) : super(key: key);

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  Timer _timer;
  DateTime _time;
  String userName;

  getUserName() async{
    String _userName = await SharedPreferencesHelper.getName();
    assert(_userName != null);
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
      textScaleFactor: 1.5,
      style: TextStyle(
        fontWeight: FontWeight.w300,
        color: studentoWhite
      ),
    );

    Text _timeWidget = Text(
      time,
      textScaleFactor: 7.5,
      style: TextStyle(
        fontWeight: FontWeight.w800,
        color: studentoWhite,
        fontStyle: FontStyle.italic,
      ),
    );

    return Column(mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _timeWidget,
        _greetingWidget,
      ],
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:studentapp/globals.dart' as globals;

class TimeTextWidget extends StatefulWidget {
  TimeTextWidget({Key key}) : super(key: key);

  @override
  _TimeTextWidgetState createState() => new _TimeTextWidgetState();
}

class _TimeTextWidgetState extends State<TimeTextWidget> {
  Timer _timer;
  DateTime _time;

  @override
  void initState() {
    super.initState();
    _time = new DateTime.now();

    const duration = const Duration(
        milliseconds: Duration.millisecondsPerSecond ~/ 4);
    _timer = new Timer.periodic(duration, _updateTime);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime(Timer _) {
    setState(() {
      _time = new DateTime.now();
    });
  }
  __getProperGreeting() {
    String greeting;
    String timePeriod;
    final timeNow = new DateTime.now();
    if (timeNow.hour < 12 && timeNow.hour > 2){
      timePeriod = "Morning";
    } else if(timeNow.hour < 17){
      timePeriod = "Afternoon";
    }
    else {
      timePeriod = "Evening";
    }
   
    greeting = "Good $timePeriod, " + globals.userName + ".";
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

    final String time = formatTime(_time);
    final String _greeting = __getProperGreeting();

    Text _greetingWidget = new Text(_greeting,
      style: new TextStyle(
        fontSize: 16.0,
        color: new Color(0xFFfafafa)
      )
    );
    var _timeWidget = new Text(time,
      style: new TextStyle(
        fontSize: 60.0,
        fontWeight: FontWeight.w800,
        color: new Color(0xFFfafafa),
        fontStyle: FontStyle.italic,
      )
    );

    final _overview  =  new Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      margin: const EdgeInsets.only(top: 20.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _timeWidget,
          _greetingWidget,
        ],
      ),
    );

    return _overview;

  }
}
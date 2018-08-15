import 'dart:async';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';

import '../model/class.dart';
import 'studento_app_bar.dart';
import '../UI/loading_page.dart';
import '../util/shared_prefs_interface.dart';
import '../util/show_message_dialog.dart';


class AddRecessDialog extends StatefulWidget {
  final int classAfterWhichRecessStarts;
  final Class recessEntryToEdit;

  AddRecessDialog.add({this.classAfterWhichRecessStarts = 5}) : recessEntryToEdit = null;

  AddRecessDialog.edit(this.recessEntryToEdit)
      : classAfterWhichRecessStarts = recessEntryToEdit.classNo - 1;

  @override
  WeightEntryDialogState createState() {
    if (recessEntryToEdit != null) {
      return WeightEntryDialogState(recessEntryToEdit, classAfterWhichRecessStarts);
    } else {
      return WeightEntryDialogState(
          null, classAfterWhichRecessStarts);
    }
  }
}

class WeightEntryDialogState extends State<AddRecessDialog> {
  Class recessEntry;
  int _classAfterWhichRecessStarts;

  DateTime _startTime;

  DateTime _endTime;

  int _noOfClasses;


  WeightEntryDialogState(this.recessEntry, this._classAfterWhichRecessStarts);

  @override
  void initState() {
    super.initState();
    initTime();
    loadNoOfClasses();
  }

  void initTime() {
    _startTime =
    recessEntry != null ? recessEntry.startTime : DateTime.now();
    _endTime =
        recessEntry != null ? recessEntry.endTime : DateTime.now();
  }

  void loadNoOfClasses() async {
    int _value = await SharedPreferencesHelper.getNoOfClasses();
    setState(() => _noOfClasses = _value);
  }


  Widget _buildAppBar(BuildContext context) => StudentoAppBar(
    title: widget.recessEntryToEdit == null
        ? "New Recess"
        : "Edit Recess",
    actions: [
      _buildSaveButton(),
    ],
  );

  Widget _buildSaveButton() => FlatButton(
    child: Text('SAVE'),
    onPressed: () {
      if (isTimeValid) {
        recessEntry = Class(
          weekDay: 0,
          endTime: _endTime,
          startTime: _startTime,
          name: "Recess 1",
          classNo: _classAfterWhichRecessStarts + 1,
        );

        Navigator
            .of(context)
            .pop(recessEntry);
      }
      else {
        showMessageDialog(
          context,
          msg: "Please check that the end time is after the start time."
        );
      }
    },
  );

  bool get isTimeValid {
    if (_startTime.isAfter(_endTime)) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (_noOfClasses == null) return loadingPage();

    String formattedStartTime = formatTime(_startTime);
    String formattedEndTime = formatTime(_endTime);
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.timelapse),
            title: Text("Start Time"),
            trailing: Text(formattedStartTime),
            onTap: () => setStartTime(),
          ),
          ListTile(
            leading: Icon(Icons.timelapse),
            title: Text("End Time"),
            trailing: Text(formattedEndTime),
            onTap: () => setEndTime(),
          ),
          ListTile(
            leading: Icon(Icons.timelapse),
            title: Text("After which class do you have this recess?"),
            onTap: () => _showClassPicker(context),
            trailing: Text(_classAfterWhichRecessStarts.toString()),
          ),
        ],
      ),
    );
  }

  String formatTime(DateTime _time) {
    var dateFormatter = DateFormat('jm'); // HOURS:MINUTES format.
    String formattedTime = _time != null ? dateFormatter.format(_time) : "Tap to set";

    return formattedTime;
  }

  void setStartTime() async {
    var selectedTime = await _showTimePicker(context);
    setState(() => _startTime = selectedTime);
  }


  void setEndTime() async {
    var selectedTime = await _showTimePicker(context);
    setState(() => _endTime = selectedTime);
  }

  void _showClassPicker(BuildContext context) {
    showDialog<int>(
      context: context,
      builder: (_) => NumberPickerDialog.integer(
        title: Text("Enter class no: "),
        initialIntegerValue: _classAfterWhichRecessStarts,
        maxValue: _noOfClasses,
        minValue: 1,
      ),
    ).then((int value) {
      if (value != null) {
        setState(() =>
          _classAfterWhichRecessStarts = value
        );
      }
    });
  }

  Future<DateTime> _showTimePicker(BuildContext context) async {
    TimeOfDay timeOfDay =
      await showTimePicker(context: context, initialTime: TimeOfDay.now());

    DateTime dateTimeObj = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      timeOfDay.hour,
      timeOfDay.minute
    );

    return dateTimeObj;
  }
}
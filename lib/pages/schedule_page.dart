import 'package:flutter/material.dart';
import '../UI/studento_app_bar.dart';
import '../UI/loading_page.dart';
import '../UI/class_widget.dart';
import '../model/class.dart';
import '../util/shared_prefs_interface.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage>  with SingleTickerProviderStateMixin {
  TabController _tabController;
  int initialIndex;
  final List<Widget> dayTabs = [
    Tab(text: "Mon"),
    Tab(text: "Tues"),
    Tab(text: "Wed"),
    Tab(text: "Thurs"),
    Tab(text: "Fri"),
  ];

  bool isScheduleSet;
  int noOfSessions;
  bool isScheduleDataLoaded = false;

  @override
  initState(){
    super.initState();
    setState(() {
      loadNoOfSessions();
      isScheduleDataLoaded = true;
    });

    getInitialIndex();
    _tabController = TabController(
      vsync: this,
      length: dayTabs.length,
      initialIndex: initialIndex,
    );
  }

  void getInitialIndex() {
    int currentDay = DateTime.now().weekday;
    bool isWeekDay =  currentDay < 6;

    if (isWeekDay) {
      // initialIndex starts from zero, but [DateTime.weekday()] returns
      // values starting from 1. To fix that, we minus 1.
      initialIndex = currentDay - 1;
    } else {
      // During the weekend, set initialIndex to 0 show the schedule for the
      // next Monday.
      initialIndex = 0;
    }
  }

  void loadNoOfSessions() async {
    noOfSessions = await SharedPreferencesHelper.getNoOfClasses();
  }

  @override
  dispose(){
    super.dispose();
    _tabController.dispose();
  }

  Widget build(BuildContext context) {
        print("noOfSessions is $noOfSessions and isScheduleSet is $isScheduleSet");

    if (!isScheduleDataLoaded) return loadingPage();

    return Scaffold(
      appBar: StudentoAppBar(
        title: "Schedule",
        bottom: TabBar(
          controller: _tabController,
          tabs: dayTabs,
          labelColor: Colors.black87,
          indicatorColor: Colors.blue,
        ),
      ),
      body: getClasses(_tabController.index),
    );
  }

  Class exampleClass1 = Class(
    classNo: 1,
    weekDay: 1,
    startTime: DateTime(2018, 3, 15, 43),
    endTime: DateTime(2018, 3, 16, 43),
    name: "Chemistry",
    location: "Room 12",
    teacher: "Panchoo"
  );

  Class exampleClass2 = Class(
    classNo: 2,
    weekDay: 12,
    startTime: DateTime.now(),
    endTime: DateTime.now().add(Duration(minutes: 14)),
    name: "Chemistry",
    location: "Room 13",
    teacher: "Phannchoo"
  );

  Widget getClasses(int dayIndex) {
    if (isScheduleSet == false){
      //TODO Add schedule widget.
      return ListView(
        children: <Widget>[
          ClassWidget(exampleClass1),
          ClassWidget(exampleClass2),
          ClassWidget(exampleClass1),
          ClassWidget(exampleClass1),
          ClassWidget(exampleClass1),
          ClassWidget(exampleClass1),
          ClassWidget(exampleClass1),
        ],
      );
    }

    return Center(child: Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.all(25.0),),
        Text("You haven't added your schedule yet.", textScaleFactor: 1.4,),
        Padding(padding: EdgeInsets.all(20.0),),
        FlatButton.icon(
          color: Theme.of(context).buttonColor,
          onPressed: (){print("You clicked this button");},
          icon: Icon(Icons.schedule),
          label: Text("Configure Schedule"),
        ),
      ],
    ));
  }

}
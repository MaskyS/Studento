import 'package:flutter/material.dart';

import '../UI/studento_app_bar.dart';
import '../UI/loading_page.dart';
import '../UI/class_widget.dart';
import '../model/class.dart';
import '../util/shared_prefs_interface.dart';
import '../util/schedule_database_client.dart';

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

  @override
  initState(){
    super.initState();
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


  @override
  dispose(){
    super.dispose();
    _tabController.dispose();
  }

  Widget build(BuildContext context) {
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
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
         ClassesList(1),
         ClassesList(2),
         ClassesList(3),
         ClassesList(4),
         ClassesList(5)
        ],
      ) ,
    );
  }

}

class ClassesList extends StatefulWidget {
  @override
  _ClassesListState createState() => _ClassesListState();

  final int weekDay;

  ClassesList(this.weekDay);
}

class _ClassesListState extends State<ClassesList> {
  int noOfClasses;
  bool isScheduleDataLoaded = false;

  var db = ScheduleDatabaseHelper();

  List<Class> classesList = <Class>[];


  void loadNoOfClasses() async {
    int _noOfClasses = await SharedPreferencesHelper.getNoOfClasses();
    setState(() => noOfClasses = _noOfClasses);
  }

  void loadSavedClasses() async{
    List classes = await db.getClasses(weekDay: widget.weekDay);
    List<Class> recesses = await db.getClasses(weekDay: 0);

    recesses.forEach((Class recess){
      int _classNo = recess.classNo;
      classes.removeWhere((_class) => _class.classNo == _classNo);
    });

    List<Class> tempList = List.from(classes)..addAll(recesses);


    DateTime dateThatWillNeverMatch =
        DateTime.now().add(Duration(days: 999999));

    List<Class> _classList = List.generate(
      noOfClasses,
      (int i) => Class(
          classNo: i+1,
          weekDay: widget.weekDay,
          startTime : dateThatWillNeverMatch,
          endTime: dateThatWillNeverMatch,
          name: "You haven't set this class yet.",
      ),
    );

    tempList.forEach((Class _class) {
      _classList.replaceRange(
        _class.classNo - 1,
        _class.classNo,
        [_class]
      );
    });

    print("$_classList");
    classesList = _classList;
    setState(() =>isScheduleDataLoaded = true);
  }

  @override
  void initState() {
    loadNoOfClasses();
    loadSavedClasses();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    if (!isScheduleDataLoaded) return loadingPage();

    return ListView.builder(
      itemCount: noOfClasses,
      itemBuilder: (_, int index) {
        return ClassWidget(classesList[index]);
      },
    );
  }
}
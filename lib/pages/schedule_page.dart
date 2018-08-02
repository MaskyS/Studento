import 'package:flutter/material.dart';
import '../UI/studento_app_bar.dart';
import '../UI/loading_page.dart';
import '../util/shared_prefs_interface.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage>  with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool isScheduleSet;
  int noOfSessions;
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
    SharedPreferencesHelper
      .getIsScheduleSet()
      .then(
        (bool value) =>
        setState(() => isScheduleSet = value ?? false)
    );

    SharedPreferencesHelper.getNoOfSessions()
    .then(
      (int value) => setState(() => noOfSessions = value)
    );

    final int currentDay = DateTime.now().weekday;
    final bool isWeekDay =  currentDay > 5;
    int initialIndex;

    if (isWeekDay) {
      // initialIndex starts at zero, but [DateTime.weekday()] returns values starting from 1.
      // To fix that, we minus 1.
      initialIndex = currentDay - 1;
    } else {
      // During the weekend, set initialIndex to 0 show the schedule for the next Monday.
      initialIndex = 0;
    }

    _tabController = TabController(
      vsync: this,
      length: dayTabs.length,
      initialIndex: initialIndex,
    );
  }

  @override
  dispose(){
    super.dispose();
    _tabController.dispose();
  }

  Widget build(BuildContext context) {
    if (isScheduleSet == null) return loadingPage();

    return Scaffold(
      appBar: StudentoAppBar(
        title: "Schedule",
        bottom: TabBar(
          controller: _tabController,
          tabs: dayTabs,
          indicatorColor: Colors.blue.shade400,
        ),
      ),
      body: getClasses(),
    );
  }

  Widget getClasses() {
    if (!isScheduleSet){
      //TODO Add schedule widget.
      return ListTile(
        contentPadding: EdgeInsets.only(right: 26.0),
        leading: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 27.0),
          color: Colors.redAccent,
          child: Text("1", style: TextStyle(color: Colors.white)),
        ),
        onTap: (){print("Hi");},
        title: Text("Mathematics"),
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget> [
            Text("Room 124"),
            Divider(indent: 20.0),
            Text("Mr. Robert"),
          ],
        ),
      );
    }

    return Column(
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
    );
  }

}
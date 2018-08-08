import 'dart:math';

import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

import 'package:after_layout/after_layout.dart';

import '../UI/studento_app_bar.dart';
import '../UI/studento_drawer.dart';
import '../UI/clock.dart';
import '../UI/vertical_divider.dart';
import '../UI/rate_dialog.dart';
import '../ads_helper.dart' as ads;
import 'package:firebase_admob/firebase_admob.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AfterLayoutMixin<HomePage>{

  @override
  void afterFirstLayout(BuildContext context){
    bool isLuckyDay = decideWhetherToShowRatingDialog();
    if (isLuckyDay) showRatingDialog();
  }

  bool decideWhetherToShowRatingDialog() {
    var randomObj = Random();
    int luckyNum = 10;
    int randomNum = randomObj.nextInt(13);
    if (randomNum == luckyNum) return true;

    return false;
  }

  void showRatingDialog(){
    showDialog(
      context: context,
      builder: (_) => RateDialog(),
    );
  }

  Widget buildButtonRow({
      @required Widget button1,
      @required Widget button2
    }) => Expanded(
      flex: 1,
      child: Row(
        children: <Widget>[
          button1,
          VerticalDivider(
            color: Colors.blue,
            width: 3.0,
          ),
          button2,
        ],
      ),
  );

  @override
  Widget build(BuildContext context) {

    List<Widget> appBarActions = <Widget>[
      IconButton(
        icon: Icon(Icons.notifications_active),
        onPressed: () =>
          print(
              "This will open up your schedule page! In the future anyway :P"),
      ),
    ];

    TextStyle appBarTitleStyle  = TextStyle(
      color: Colors.black,
      fontFamily: 'Montserrat',
      fontSize: 20.0,
      fontWeight: FontWeight.w400,
    );

    PreferredSizeWidget appBar = StudentoAppBar(
      title: "STUDENTO",
      actions: appBarActions,
      titleStyle: appBarTitleStyle,
    );

    Widget clockContainer() => Expanded(
      flex: 2,
      child: Container(
        alignment: Alignment.center,
        constraints: BoxConstraints.expand(),
        color: Colors.deepPurpleAccent,
        child: Clock(),
      ),
    );

    Widget pastPapersButton = HomePageButton(
      label: "PAST PAPERS",
      iconFileName: "exam_icon.png",
      routeToBePushedWhenTapped: 'past_papers_page',
    );

    Widget scheduleButton = HomePageButton(
      label: "SCHEDULE",
      iconFileName: "schedule_icon.png",
      routeToBePushedWhenTapped: 'schedule_page',
    );

    Widget todoListButton = HomePageButton(
      label: "TODO LIST",
      iconFileName: "todo-list_icon.png",
      routeToBePushedWhenTapped: 'todo_list_page',
    );

    Widget topicNotesButton = HomePageButton(
      label: "TOPIC NOTES",
      iconFileName: "notes_icon.png",
      routeToBePushedWhenTapped: 'topic_notes_page',
    );

    Widget buttonRow1 = buildButtonRow(
      button1: pastPapersButton,
      button2: scheduleButton
    );

    Widget buttonRow2 = buildButtonRow(
      button1: todoListButton,
      button2: topicNotesButton
    );

    return Scaffold(
      appBar: appBar,
      drawer: StudentoDrawer(),
      body:Column(
        children: <Widget>[
          clockContainer(),
          buttonRow1,
          Divider(height: 3.0, color: Colors.blue,),
          buttonRow2,
        ],
      ),
    );
  }
}

class HomePageButton extends StatefulWidget {
  @override
  _HomePageButtonState createState() => _HomePageButtonState();

  HomePageButton({
    @required this.label,
    @required this.iconFileName,
    @required this.routeToBePushedWhenTapped,
  });

  final String label;

  final String iconFileName;

  final String routeToBePushedWhenTapped;
}

class _HomePageButtonState extends State<HomePageButton> {

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: ads.appId);
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  static final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    contentUrl: 'http://cambridgeinternational.org',
    testDevices: null,
    childDirected: false,
    gender: MobileAdGender.unknown,
  );
  InterstitialAd _interstitialAd;

  InterstitialAd createInterstitialAd() => InterstitialAd(
    adUnitId: ads.adUnitId,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event $event");
    },
  );

  void showInterstitialAd() {
    _interstitialAd?.dispose();
    _interstitialAd = createInterstitialAd()..load();
    _interstitialAd?.show();
  }

  Widget icon() => Expanded(
    flex: 1,
    child: Image(
      fit: BoxFit.contain,
      image: AssetImage("assets/icons/${widget.iconFileName}"),
    ),
  );

  final TextStyle labelStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  Widget labelText() => Expanded(flex:1, child: Text(
    widget.label,
    textScaleFactor: 1.2,
    style: labelStyle,
  ));

  @override
  Widget build(BuildContext context) {

    buttonsContainer() => Container(
      alignment: Alignment.center,
      color: Colors.white70,
      constraints: BoxConstraints.expand(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(padding: EdgeInsets.all(20.0)),
          icon(),
          Padding(padding: EdgeInsets.all(5.0)),
          labelText(),
        ],
      ),
    );

    return Expanded(
      child: Tooltip(
      verticalOffset: 5.0,
      message: widget.label,
        child: InkWell(
          onTap: () => pushRoute(context),
          child: buttonsContainer(),
        ),
      ),
    );
  }

  void pushRoute(BuildContext context){
     Navigator.of(context).pushNamed(widget.routeToBePushedWhenTapped);
  }
}
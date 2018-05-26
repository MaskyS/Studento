import 'dart:math';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

import 'setup.dart';

/// Based on Original Flutter Code, which was written by the Flutter project
/// authors. Please see the AUTHORS file of the Flutter project for details.
/// All rights reserved. Use of this source code is governed by a BSD-style
/// license that can be found in the Flutter project's LICENSE file.
class IntroPage extends StatefulWidget {
  @override
  State createState() => new IntroPageState();
}

class IntroPageState extends State<IntroPage> {

  final _controller = new PageController();

  static const _kDuration = const Duration(milliseconds: 300);

  static const _kCurve = Curves.ease;

  final _kArrowColor = Colors.black.withOpacity(0.8);

  final List<Widget> _pages = <Widget>[
    new IntroPageModel(
      title: "Past Papers",
      subtitle: "Access past papers offline anytime, anywhere, from your pocket.",
      mainIcon: Icons.library_books,
    ),
    new IntroPageModel(
      title: "Topic Notes",
      subtitle: "The best notes you can find, so you can learn without hassle.",
      mainIcon: Icons.subtitles,
    ),
    new IntroPageModel(
      title: "Todo List",
      subtitle: "A virtual todo list that brings tracking homework and tasks to the next level.",
      mainIcon: Icons.assignment,
    ),
    new IntroPageModel(
      title: "Schedule",
      subtitle: "Be productive and keep track of classes by using Studento's schedule feature",
      mainIcon: Icons.table_chart,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xFF5fbff9),
      body: new IconTheme(
        data: new IconThemeData(color: _kArrowColor),
        child: new Stack(
          children: <Widget>[
            PageView.builder(
              physics: new AlwaysScrollableScrollPhysics(),
              controller: _controller,
              itemBuilder: (BuildContext context, int index) {
                return _pages[index % _pages.length];
              },
            ),
            Positioned(
              bottom: 70.0,
              left: 0.0,
              right: 0.0,
              child: new Center(
                  child: new DotsIndicator(
                    controller: _controller,
                    itemCount: _pages.length,
                    onPageSelected: (int page) {
                      _controller.animateToPage(
                        page,
                        duration: _kDuration,
                        curve: _kCurve,
                      );
                    },
                  ),
                ),
            ),
            new Positioned(
              bottom: 20.0,
              left: 0.0,
              right: 0.0,
              child: new Center(
                child: FlatButton(
                  color: Colors.deepPurpleAccent,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  child: Text("GET STARTED!"),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => Setup())),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// An indicator showing the currently selected page of a PageController
class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.white,
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 8.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 2.0;

  // The distance between the center of each dot
  static const double _kDotSpacing = 25.0;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return new Container(
      width: _kDotSpacing,
      child: new Center(
        child: new Material(
          color: color,
          type: MaterialType.circle,
          child: new Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: new InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, _buildDot),
    );
  }
}

class IntroPageModel extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData mainIcon;

  IntroPageModel({@required this.title, @required this.subtitle, @required this.mainIcon});
  @override
  Widget build(BuildContext context) {
    return new ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.all(40.0),),
          new Text(
            title,
            textScaleFactor: 2.0,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.all(55.0),
          ),
          Icon(
            mainIcon,
            size: 100.0,
            color: Color(0xFFFAFAFA),
          ),
          Padding(padding: EdgeInsets.all(55.0),),
          new Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
            textScaleFactor: 1.2,
          )
        ],
      ),
    );
  }
}
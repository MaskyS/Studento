import 'package:flutter/material.dart';
import 'time_text_widget.dart';

/// The SliverAppBar that is used exclusively in the Home Page.
class SliverStudentoAppBar extends StatelessWidget {
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      centerTitle: true,
      expandedHeight: 290.0,
      backgroundColor: Colors.deepPurpleAccent,
      flexibleSpace: TimeTextWidget(),
      title: Text(
        "Studento",
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Mina',
          fontSize: 26.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.notifications_active),
          /// TODO 1
          /// TODO 2
          color: Colors.white,
          onPressed: () =>
            print(
                "This will open up your schedule page! In the future anyway :P"),
        ),
      ],

    );
  }
}

///TODO 1:
/// Implement dynamic icon setup, i.e. The icon should change depending on how
/// close the deadline is.

///TODO 2 :
/// Change the icon's color depending on state. i.e. how close
/// the next deadline is, or if user has any homework left.
/// Something like: color: (__isDeadlineApproaching) ? red : green

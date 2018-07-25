import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

/// A template Widget used for creating each of the setup pages. This Widget
/// creates a [Scaffold] with a configurable [FloatingActionButton], a body
/// that contains a gradient background at the top which has a centered Icon,
/// title of [page], [subtitle], and a sub-[body].
class SetupPage extends StatefulWidget {
  /// The Icon that's displayed in the center of the Container at the top of
  /// the [SetupPage].
  final IconData leadIcon;

  /// The title Text that's right below the Icon and its Container, denoting
  /// what the [SetupPage] is about.
  final String title;

  /// The subtitle Text that's right below the title Text, describing further
  /// the [SetupPage].
  final String subtitle;

  /// The main body of the [SubjectPage], containing [Widget]s such as [TextField]s,
  /// [Slider]s, etc that allow the user to configure Studento.
  final Widget body;

  /// The callback function to execute when the [FloatingActionButton] on this
  /// [SetupPage] is pressed.
  final VoidCallback onFloatingButtonPressed;

  SetupPage(
      {@required this.leadIcon,
      this.title,
      this.subtitle,
      this.body,
      this.onFloatingButtonPressed});
  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  BoxDecoration topBackgroundDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: FractionalOffset(0.0, 0.0),
      end: FractionalOffset(2.0, 0.0),
      stops: [0.0, 0.5],
      tileMode: TileMode.clamp,
      colors: [
        Colors.deepPurpleAccent,
        Color(0xFF5fbff9),
      ],
    ),
  );
 
  Widget buildTopBackground(IconData icon) => Column(
    children: <Widget>[
      Container(
        height: 200.0,
        width: MediaQuery.of(context).size.width,
        child: Icon(
          icon,
          size: 50.0,
          color: Colors.white,
        ),
        decoration: topBackgroundDecoration,
      ),
    ],
  );

  Widget buildTitleAndSubtitle() => Padding(
    padding: EdgeInsets.only(left: 25.0, top: 40.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.title,
          textAlign: TextAlign.start,
          textScaleFactor: 1.5,
        ),
        Padding(padding: EdgeInsets.only(top: 15.0)),
        Text(
          widget.subtitle,
          style: TextStyle(color: Colors.black54),
        ),
      ],
    ),
  );

  Widget buildNextButton() => FloatingActionButton(
    child: Icon(Icons.arrow_forward),
    onPressed: widget.onFloatingButtonPressed,
    backgroundColor: Color(0xFF5fbff9), // Imperialish blue
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildNextButton(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildTopBackground(widget.leadIcon),
          buildTitleAndSubtitle(),
          Expanded(
            flex: 2,
            child:  Padding(
              padding: EdgeInsets.all(8.0),
              child: widget.body,
            ),
          ),
        ],
      ),
    );
  }

}
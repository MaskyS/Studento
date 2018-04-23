import 'package:flutter/material.dart';
import '../UI/StudentoAppBar.dart';
import '../UI/StudentoDrawer.dart';
import 'package:flutter_radial_menu/flutter_radial_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
/// TODO
class SyllabusPage extends StatelessWidget {
  static String routeName = "syllabus_page";
  GlobalKey<RadialMenuState> _menuKey = new GlobalKey<RadialMenuState>();
  String _getSubjectUrl(){
    // TODO Implement functionality to get the appropriate URL for each
    // subject. The URLs should be stored into a json file. We also need a
    // key-value pair that indicates the expiry date of syllabi so it can be
    // promptly updated.
    return "https://docs.google.com/gview?embedded=true&url=http://www.orimi.com/pdf-test.pdf";
  }
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new StudentoAppBar(),
      drawer: new StudentoDrawer(),
      // TODO Increase size and modify the setup of central button so it 1) is
      // is bigger and 2) it's always open on initial load and 3) The icon is
      // a relevant one instead of the hamburger icon.
      body: new RadialMenu(
        key: _menuKey,
        items: _getRadialMenuItems(),
        radius: 125.0,
        onSelected: (value){
          _menuKey.currentState.reset();
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context){
              // TODO We need a loader here to show that the page is loading.
              // Else user might think the app is broken because of the near-
              // blank screen.
              return new WebviewScaffold(
                url: _getSubjectUrl(),
                appBar: new StudentoAppBar(),
                withZoom: true,
                withLocalStorage: true,
              );
            }),
          );
        },
      ),
    );
  }

  List<RadialMenuItem> _getRadialMenuItems() /*async*/{
    Color _backgroundColor;
    int _colorsIndex = 0;

    List<RadialMenuItem> items = [];
    // TODO Once we get Shared Pref up and running, we should fetch the list of
    // subjects. Updated code should look like:
    //
    // SharedPreferences userConfig = await SharedPreferences.getInstance();
    // userConfig.getString("level");
    // List listOfSubjects = userConfig.getStringList("list_of_subjects");
    List<String> listOfSubjects = ["English", "French", "Mathematics", "Chemistry", "Physics", "Biology", "Add Maths", "Computer \n Science"];
    String level = "A Level";
    List<Color> possibleColors = [
      // Studento Blue
      Colors.blue[700],
      // Studento Pink
      const Color(0xFFfc6dab),
      // Studento Black
      Colors.black87,
      // Studento Orange
      const Color(0xFFf86624),
      //  Studento Purple
      Colors.deepPurpleAccent,
    ];
    // TODO Before putting the subject strings into the Text widgets, we need
    // to add a \n character after a " " character so there isn't any overflow.
    for (var index = 0; index < listOfSubjects.length; index++) {
      _backgroundColor = possibleColors[_colorsIndex];
      items.add(new RadialMenuItem(
        child: new Center(child: new Text(
          listOfSubjects[index].toUpperCase(),
          style: new TextStyle(
            color: Colors.white,
            fontSize: 9.0,
            fontWeight: FontWeight.w100,
          ),
        )),
        tooltip: "${listOfSubjects[index]}",
        value: "$level${listOfSubjects[index]}",
        backgroundColor: _backgroundColor,
        size: 70.0,
      ));
      _colorsIndex += 1;
      if (_colorsIndex > 4){
        _colorsIndex = 0;
      }

    }

    return items;
  }

}
import 'dart:async';
import 'package:flutter/material.dart';
import '../UI/StudentoAppBar.dart';
import '../UI/StudentoDrawer.dart';
import 'package:flutter_radial_menu/flutter_radial_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class SyllabusPage extends StatefulWidget{
  static String routeName = "syllabus_page";
  @override
  State<StatefulWidget> createState() {
    return new SyllabusPageState();
  }
}

class SyllabusPageState extends State<SyllabusPage>{

  List<String> listOfSubjects = ["General Paper", "French", "Mathematics", "Chemistry", "Physics", "Biology", "Economics", "Computer Science"];
  String level = "A";
  GlobalKey<RadialMenuState> _menuKey = new GlobalKey<RadialMenuState>();
  GlobalKey<ScaffoldState> _webViewScaffoldKey = new GlobalKey();
  var webViewPlugin = new FlutterWebviewPlugin();
  bool _isHidden = true;
  String url;
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  String _getSubjectUrl(String value){

    if (value.substring(0,1) == 'A'){
      switch (value.substring(1)) {
        case "Accounting":
          url = "/329550-2019-2021-syllabus.pdf";
        break;
        case "Art & Design":
          url = '/416423-2019-2021-guide-to-administering-art-design.pdf';
        break;
        case "Biology":
          url = "/329527-2019-2021-syllabus.pdf";
        break;
        case "Business":
          url = '/329500-2019-2021-syllabus.pdf';
        break;
        case "Chemistry":
          url = '/329530-2019-2021-syllabus.pdf';
        break;
        case "Computer Science":
          url = "/415023-2020-syllabus.pdf";
        break;
        case "Design & Technology":
          url = "/415058-2020-2022-syllabus.pdf";
        break;
        case "Design & Textiles":
          url = "/268507-2018-syllabus.pdf";
        break;
        case "Economics":
          url = "/329552-2019-2021-syllabus.pdf";
        break;
        case "English Literature":
          url = "/415054-2020-syllabus.pdf";
        break;
        case "French AS":
          url = "/414882-2020-2022-syllabus.pdf";
        break;
        case "French":
          url ="/415062-2020-2022-syllabus.pdf";
        break;
        case "Food Studies":
          url = "/202618-2017-2019-syllabus.pdf";
        break;
        case "General Paper":
          url = "/415188-2019-2021-syllabus.pdf";
        break;
        case "Geography":
          url = "/253885-2018-2020-syllabus.pdf";
        break;
        case "Mathematics":
          url = "/415060-2020-2022-syllabus.pdf";
        break;
        case "Physics":
          url = "/329533-2019-2021-syllabus.pdf";
        break;
        case "Travel & Tourism":
          url = "/414997-2020-2022-syllabus.pdf";
        break;
        default:
          new Exception("Subject not found. Please file a bug.");
      }
    }
    // TODO Implement functionality to get the appropriate URL for each
    // subject. The URLs should be stored into a json file. We also need a
    // key-value pair that indicates the expiry date of syllabi so it can be
    // promptly updated.
    url = "https://docs.google.com/gview?embedded=true&url=http://www.cambridgeinternational.org/images$url";
    return url;
  }

 Future<Null> _handleGetOfflineButtonPressed(BuildContext context) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Download syllabus'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Padding(padding: const EdgeInsets.only(top: 20.0)),
                new Text("Storing syllabus offline is a pro feature. By paying for Studento Pro, you help our developers survive and create more cool features like this one ;)",
                  textScaleFactor: 0.8,
                  style: new TextStyle(fontStyle: FontStyle.italic,)
                ),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Starve devs'),
              onPressed: () {
                // Close the dialog.
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text('Get Pro'),
              onPressed: () {
                print("this should lead to payment options");
                // Close the dialog.
                Navigator.of(context).pop();
                webViewPlugin.launch(url, hidden: false, withLocalStorage: true,);

              },
            ),
          ],
        );
      },
    );
  }

  @override
  initState(){
    _onStateChanged = webViewPlugin.onStateChanged.listen((WebViewStateChanged state){
      if (state == WebViewState.finishLoad){
        print("${state.type}");
        setState(() {
          _isHidden = false;
        });
      }
      else {
        _isHidden = true;
      }
    });
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
          FlutterWebviewPlugin().launch(_getSubjectUrl(value), hidden: _isHidden);

          _menuKey.currentState.reset();
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context){
              // TODO We need a loader here to show that the page is loading.
              // Else user might think the app is broken because of the near-
              // blank screen.
              return new WebviewScaffold(
                url: _getSubjectUrl(value),
                appBar: new StudentoAppBar(actions: <Widget>[
                  new IconButton(
                    icon: new Icon(Icons.file_download),
                    color: Colors.white,
                    onPressed: () {
                      FlutterWebviewPlugin().close();
                      _handleGetOfflineButtonPressed(context);},
                  ),
                ],),
                withLocalStorage: true,
              );
            }),
          );
        },
      ),
    );
  }

  String _textFormat(String text){
    // Convert text to uppercase.
    text = text.toUpperCase();
    // If the subject name is long (& thus contains spaces), we insert a
    // newline after that space to break up the text into two lines. This helps
    //  it fit into the circle.
    text.replaceAll(' ', ' \n');
    return text;
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
        child: new Center(child: new Text(_textFormat(listOfSubjects[index]),
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

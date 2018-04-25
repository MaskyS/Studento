import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../UI/StudentoAppBar.dart';
import '../UI/StudentoDrawer.dart';
import 'package:flutter_radial_menu/flutter_radial_menu.dart';
// import 'package:shared_preferences/shared_preferences.dart';
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
  Map urlList;
  GlobalKey<RadialMenuState> _menuKey = new GlobalKey<RadialMenuState>();
  GlobalKey<ScaffoldState> _webViewScaffoldKey = new GlobalKey();
  var webViewPlugin = new FlutterWebviewPlugin();
  bool _isHidden = true;
  String url;
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  String _getSubjectUrl(List value) {
    String _level = value[0];
    String _subject = value[1];

    url = urlList["$_level level"][_subject]['url'];
    url = "https://docs.google.com/gview?embedded=true&url=http://www.cambridgeinternational.org/images" + "$url";

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
                  style: new TextStyle(fontStyle: FontStyle.italic,),
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
  void initState() {
    // TODO Once we get Shared Pref up and running, we should fetch the list of
    // subjects. Updated code should look like:
    //
    // SharedPreferences userConfig = await SharedPreferences.getInstance();
    // userConfig.getString("level");
    // List listOfSubjects = userConfig.getStringList("list_of_subjects");
    // Get the url from our subjects_syllabus_urls.json file.
    rootBundle.loadString('assets/json/subjects_syllabus_urls.json').then((fileData){
      urlList = json.decode(fileData);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar:new StudentoAppBar(),
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
              const userAgentString = "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36";
              // TODO We need a loader here to show that the page is loading.
              // Else user might think the app is broken because of the near-
              // blank screen.
              return new WebviewScaffold(
                userAgent: userAgentString,
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

  List<RadialMenuItem> _getRadialMenuItems() /*async*/{

    List<RadialMenuItem> items = [];

    for (var index = 0; index < listOfSubjects.length; index++) {
      String subjectNameString = listOfSubjects[index];
      // If subject name is more than 1 word, split into two lines so the text
      // doesn't overflow the button.
      subjectNameString.replaceFirst(" ", " \n");
      subjectNameString.toUpperCase(); // Prettify by converting to uppercase.

      items.add(new RadialMenuItem(
        size: 70.0,
        backgroundColor: Colors.white,
        value: [level, listOfSubjects[index]],
        tooltip: listOfSubjects[index],
        child: new Text(subjectNameString,
          style: new TextStyle(
            color: Colors.black,
            fontSize: 9.0,
            fontWeight: FontWeight.w100,
          ),
          textAlign: TextAlign.center,
        ),
      ));
    }

    return items;
  }

}

// import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../UI/StudentoAppBar.dart';
import '../UI/StudentoDrawer.dart';
import '../UI/radial_menu/flutter_radial_menu.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class SyllabusPage extends StatefulWidget{
  static String routeName = "syllabus_page";
  @override
  State<StatefulWidget> createState() {
    return new SyllabusPageState();
  }
}

class SyllabusPageState extends State<SyllabusPage>{

  List<String> listOfSubjects = ["General Paper AS", "French", "Mathematics", "Chemistry", "Physics", "Biology", "Economics", "Computer Science"];
  String level = "A";
  Map urlList;
  GlobalKey<RadialMenuState> _menuKey = new GlobalKey<RadialMenuState>();
  GlobalKey<ScaffoldState> _webViewScaffoldKey = new GlobalKey();
  var webViewPlugin = new FlutterWebviewPlugin();
  String url;

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
              return new WebviewScaffold(
                key: _webViewScaffoldKey,
                userAgent: userAgentString,
                url: _getSubjectUrl(value),
                withLocalStorage: true,
                appBar: new StudentoAppBar(actions: <Widget>[
                  new IconButton(
                    icon: new Icon(Icons.file_download),
                    color: Colors.white,
                    onPressed: () {
                      // TODO [Snackbar] is not being shown as it needs a
                      // [Scaffold] to work with. As [WebViewScaffold] doesn't
                      // extend the [Scaffold] class, we're leaving this as is
                      // until that is fixed. Else we'll need our own custom
                      // implementation of WebView.
                      Scaffold.of(context).showSnackBar(new SnackBar(
                        content: new Text("Storing syllabus offline is a Pro feature. Consider helping our developers survive!"),
                        duration: new Duration(seconds: 5),
                        action: new SnackBarAction(
                          label: "GET PRO",
                          onPressed: _getPro,
                        ),
                      ),);
                    },
                  ),
                ],),
              );
            }),
          );
        },
      ),
    );
  }

  List<RadialMenuItem> _getRadialMenuItems() {

    List<RadialMenuItem> items = [];

    for (var index = 0; index < listOfSubjects.length; index++) {
      String subjectNameString = listOfSubjects[index];

      items.add(new RadialMenuItem(
        size: 70.0,
        value: [level, listOfSubjects[index]],
        tooltip: listOfSubjects[index],
        buttonText: subjectNameString,
      ));
    }

    return items;
  }

  String _getSubjectUrl(List value) {
    String _level = value[0];
    String _subject = value[1];

    url = urlList["$_level level"][_subject]['url'];
    url = "https://docs.google.com/gview?embedded=true&url=http://www.cambridgeinternational.org/images" + "$url";

    return url;
  }

  void _getPro(){
    // TODO Implement payment method.
    print("this will help developers survive.");
  }

}

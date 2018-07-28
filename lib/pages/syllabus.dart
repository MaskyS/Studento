import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import '../UI/studento_app_bar.dart';
import '../UI/studento_drawer.dart';
import '../UI/subjects_staggered_grid_view.dart';

class SyllabusPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SyllabusPageState();
}

class SyllabusPageState extends State<SyllabusPage> {
  /// List of urls for accessing syllabus.
  Map urlList;

  @override
  void initState() {
    super.initState();
    checkifConnected();
    getUrlList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: StudentoDrawer(),
      appBar: StudentoAppBar(title: "Syllabus"),
      body: SubjectsStaggeredListView(launchWebView),
    );
  }

  void getUrlList() {
    rootBundle
        .loadString('assets/json/subjects_syllabus_urls.json')
        .then((fileData) {
        urlList = json.decode(fileData);
    });
  }

  /// Leads users to the Developer Feeding Area (satire).
  void _getPro() {
    // TODO Implement payment method.
    print("this will help developers survive.");
  }

  /// Gets the syllabus url for the given [subject] of the given [level] from the
  /// given [urlList].
  String _getSubjectUrl(String subject, String level, Map urlList) {
    String url;

    url = urlList["$level"][subject]['url'];
    url =
        "https://docs.google.com/gview?embedded=true&url=http://www.cambridgeinternational.org/images" +
            "$url";

    return url;
  }

  /// Shows a snackbar informing users that offline syllabus is Pr0,
  /// along with a button to help them feed the developers.
  void _showSnackBar(BuildContext context) {
    // TODO [Snackbar] is not being shown as it needs a
    // [Scaffold] to work with. As [WebViewScaffold] doesn't
    // extend the [Scaffold] class, we're leaving this as is
    // until that is fixed. Else we'll need our own custom
    // implementation of WebView.
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Storing syllabus offline is a Pro feature. Consider helping our developers survive!"),
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: "GET PRO",
          onPressed: _getPro,
        ),
      ),
    );
  }

  void launchWebView(String subject, String level) {
    // Prevent Navigational state nests (i.e tapping back forever to get back
    // to the home page).
    Navigator.popUntil(context, ModalRoute.withName('home_page'));

    /// Open up the WebView Scaffold which will display the pdf document of the
    /// requested syllabus.
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        const userAgentString =
            "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36";
        return WebviewScaffold(
          userAgent: userAgentString,
          url: _getSubjectUrl(subject, level, urlList),
          withLocalStorage: true,
          appBar: StudentoAppBar(
            title: "Syllabus",
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.file_download),
                color: Colors.white,
                onPressed: () => _showSnackBar(context),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// In this free version of Studento, syllabus are only available online.
  /// To prevent any nasty errors, we check if the device is connnected
  /// beforehand, and display an [AlertDialog] if we're offline.
  ///
  /// One thing to note is that if the user is connected to a mobile hotspot
  /// without internet connection, this method is not going to work.
  void checkifConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
            contentPadding: const EdgeInsets.all(20.0),
            title: Text("Connection error"),
            content: Text(
                "Accessing syllabus requires an internet connection. Please connect to the internet and try again."),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () => Navigator
                  .of(context)
                  .popUntil(ModalRoute.withName('home_page')
                ),
              ),
            ],
        ),
      );
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import '../UI/studento_app_bar.dart';
import '../UI/studento_drawer.dart';
import '../UI/loading_page.dart';
import '../UI/subjects_staggered_grid_view.dart';
import '../model/subject.dart';

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

  void getUrlList() {
    rootBundle
        .loadString('assets/json/subjects_syllabus_urls.json')
        .then((fileData) {
          setState(() {
            urlList = json.decode(fileData);
          });
    });
  }

  /// In this free version of Studento, syllabus are only available online.
  /// To prevent any nasty errors, we check if the device is connnected
  /// beforehand, and display an [AlertDialog] if we're offline.
  ///
  /// One thing to note is that if the user is connected to a mobile hotspot
  /// without internet connection, this method is not going to work.
  void checkifConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    bool isNoInternetConnection =
        connectivityResult == ConnectivityResult.none;

    if (isNoInternetConnection) {
      showNoInternetAlertDialog();
    }
  }

  void showNoInternetAlertDialog() {
    String _errorMsg = "Accessing syllabus requires an internet connection. Please connect to the internet and try again.";
    List<Widget> actionButtons = <Widget>[FlatButton(
      child: Text("OK"),
      onPressed: returnToHomePage()
    )];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.all(20.0),
        title: Text("Connection error"),
        content: Text(_errorMsg),
        actions: actionButtons,
      ),
    );
  }

  returnToHomePage() => Navigator.of(context)
      .popUntil(ModalRoute.withName('home_page'));


  @override
  Widget build(BuildContext context) {
    if (urlList == null) return loadingPage();
    return Scaffold(
      drawer: StudentoDrawer(),
      appBar: StudentoAppBar(title: "Syllabus"),
      body: SubjectsStaggeredListView(launchWebView),
    );
  }

  void launchWebView(Subject subject) {
    const userAgentString =
            "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36";

    List<Widget> appBarActions = <Widget>[
      IconButton(
        icon: Icon(Icons.file_download),
        color: Colors.white,
        onPressed: () => _showSnackBar(context),
    )];

    // Prevent Navigational state nests (i.e tapping back forever to get back
    // to the home page).
    returnToHomePage();

    /// Open up the WebView Scaffold which will display the pdf document of the
    /// requested syllabus.
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => WebviewScaffold(
        userAgent: userAgentString,
        url: _getSubjectUrl(subject, urlList),
        withLocalStorage: true,
        appBar: StudentoAppBar(
          title: "Syllabus",
          actions: appBarActions,
        ),
      )),
    );
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

  /// Leads users to the Developer Feeding Area (satire).
  void _getPro() {
    // TODO Implement payment method.
    print("this will help developers survive.");
  }

  /// Gets the syllabus url for the given [subject] of the given [level] from the
  /// [urlList].
  String _getSubjectUrl(Subject subject, Map urlList) {
    String googlePdfViewerUrlPrefix = "https://docs.google.com/gview?embedded=true&url=";
    String cambridgeSyllabusUrlPrefix = "http://www.cambridgeinternational.org/images";
    String subjectSpecificUniqueUrlComponent =  urlList["${subject.subjectCode}"]['url'];

    String url =
        googlePdfViewerUrlPrefix
        + cambridgeSyllabusUrlPrefix
        + subjectSpecificUniqueUrlComponent;

    return url;
  }
}

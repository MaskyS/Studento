import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import '../pages/past_paper_details_select.dart';
import  '../UI/TopicsListPage.dart';
import '../UI/StudentoAppBar.dart';

// ------------------------ PRIVATE FUNCTIONS ----------------------------- //

/// Gets the syllabus url for the given [subject] of the given [url] from the
/// given [urlList].
String _getSubjectUrl(String subject, String level, Map urlList) {
  String url;

  url = urlList["$level level"][subject]['url'];
  url = "https://docs.google.com/gview?embedded=true&url=http://www.cambridgeinternational.org/images" + "$url";

  return url;
}

/// Leads users to the Developer Feeding Area (DFA).
void _getPro(){
  // TODO Implement payment method.
  print("this will help developers survive.");
}

/// Shows a snackbar informing users that offline syllabus is Pr0,
/// along with a button to help them feed the developers.
void _showSnackBar(BuildContext context){
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
}

// ---------------------- END PRIVATE FUNCTIONS ------------------------- //


/// Prettifies the subject name by converting the name to uppercase and
/// breaking lengthy names into two lines.
String prettifySubjectName(String subjectName){
  // Convert to uppercase.
  subjectName = subjectName.toUpperCase();
  // We determine if the subject name is lengthy by checking if it contains a space,
  // then split the name into two lines for better aesthetic.
  subjectName = subjectName.replaceFirst(" ", " \n");
  return subjectName;
}

/// When subject card is tapped, this function will push a new page, depending
/// on what argument is given to the [onTapFunction] parameter.
void handleonTap(BuildContext context, String subjectName, String level, String onTapFunction, {Map urlList}) {

  // We need the urlList for [_getSubjectUrl].
  if (onTapFunction == 'syllabusPage'){
    assert(urlList != null);
  }

  switch (onTapFunction) {
    case 'pastPapersPage':
      // Open the Past Papers details selection page.
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (BuildContext context) => new PaperDetailsSelectionPage(subjectName, level)),
      );
    break;

    case 'syllabusPage':
    /// Open up the WebView Scaffold which will display the pdf document of the
    /// requested syllabus.
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context){
          const userAgentString = "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36";
          return new WebviewScaffold(
            userAgent: userAgentString,
            url: _getSubjectUrl(subjectName, level, urlList),
            withLocalStorage: true,
            appBar: new StudentoAppBar(
              title: new Text("Syllabus"),
              actions: <Widget>[
              new IconButton(
                icon: new Icon(Icons.file_download),
                color: Colors.white,
                onPressed: () => _showSnackBar(context),
              ),
            ],),
          );
        }),
      );
    break;

    case 'topicNotesPage':
    // Open a page containing the topic list for the selected subject.
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (BuildContext context) => new SubjectTopicsListPage(subjectName, level)),
      );
    break;
  }
}
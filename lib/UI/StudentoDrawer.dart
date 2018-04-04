import 'package:flutter/material.dart';
import '../pages/HomePage.dart';
import '../pages/SyllabusPage.dart';
import '../pages/EventsPage.dart';
import '../pages/MarksCalculatorPage.dart';
import '../pages/GetProPage.dart';
import '../pages/SendFeedbackPage.dart';
import '../pages/SettingsPage.dart';


class DrawerFragment extends StatelessWidget{
  final IconData icon;
  final String title;
  final String subtitle;
  final String pageNamerouteName;

  DrawerFragment(this.icon, this.title, this.subtitle, this.pageNamerouteName);

  @override
  Widget build(BuildContext context){
    _onTap(pageNamerouteName) {
      Navigator.popAndPushNamed(context, pageNamerouteName);
    }

    return new ListTile(
      leading: new Icon(icon),
      title: new Text(title),
      subtitle: new Text(subtitle),
      onTap: () => _onTap(pageNamerouteName),
    );
  }

}

class StudentoDrawer extends StatelessWidget {
  // Store quote in a var so different quotes can be displayed.
  static String quoteString = "\"Failure is not an option here. If things are failing, you are not innovating enough.\"";
  //The text Widget for the quote.
  static var quoteText  = new Container(
    alignment: Alignment.center,
    padding: new EdgeInsets.symmetric(vertical: 20.0),
    child: new Text(quoteString,
      style: new TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 18.0,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    ),
  );

  // Store author name in a var so that different quotes can be displayed.
  static String authorNameString = "Elon Musk";
  // The text Widget for the author name.
  static var  quoteAuthorText = new Container(
    child: new Text(('- ' + authorNameString),
      textAlign: TextAlign.end,
      style: new TextStyle(
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    ),
    alignment: FractionalOffset.bottomRight,
    padding: new EdgeInsets.only(top: 5.0),
  );

  // Place quote and author widgets in a DrawerHeader.
  var header = new DrawerHeader(
    decoration: new BoxDecoration(
      color: Colors.deepPurpleAccent,
    ),

    child: new Column(
      children: <Widget>[
        quoteText,
        quoteAuthorText,
      ] 
    ),
  );

  var homePageFragment = new DrawerFragment(Icons.home, "Home", "Go back to the home page.", HomePage.routeName);
  var syllabusPageFragment = new DrawerFragment(Icons.book, "Syllabus", "Access the syllabus of your subjects.", SyllabusPage.routeName);
  var eventsFragment = new DrawerFragment(Icons.notifications, "Events", "View or add reminders for exams/events.", EventsPage.routeName);
  var marksCalculatorFragment = new DrawerFragment(Icons.assessment, "Marks Calculator", "Input your assignment scores, get your final mark. Simple.", MarksCalculatorPage.routeName);

  var getProFragment = new DrawerFragment(Icons.card_membership, "Get Pro", "Buy us a cup of chai, we'll help you get rid of ads!", GetProPage.routeName);
  var sendFeedbackFragment = new DrawerFragment(Icons.feedback, "Send Feedback", "Report a nasty bug or send awesome ideas our way.", SendFeedbackPage.routeName);
  var settingsFragment = new DrawerFragment(Icons.settings, "Settings", "Configure your app settings.", SettingsPage.routeName);

  Widget build(BuildContext context){
    // Put the header and all the fragments together in a ListView.
    var fragmentListView= new ListView(children: [header, homePageFragment, syllabusPageFragment, eventsFragment, marksCalculatorFragment, 
      new Divider(), 
      getProFragment, settingsFragment, sendFeedbackFragment, 
    ]);

    final drawer = new Drawer(child: fragmentListView);
    return drawer;
  }

}
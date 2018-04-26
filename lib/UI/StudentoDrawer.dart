import 'package:flutter/material.dart';
import '../globals.dart' as globals;
import '../UI/RandomQuoteContainer.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final bool usedInHomePage;

  StudentoDrawer({this.usedInHomePage : false});

  static void _launchBugReportingWebsite() async {
    const url = 'https://github.com/MaskyS/studento/issues/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open $url. Check your internet connection and try again.';
    }
  }

  // Place quote and author widgets located in RandomQuotesContainer() into the
  // DrawerHeader.
  final drawerHeader = new DrawerHeader(
    decoration: new BoxDecoration(
      color: Colors.deepPurpleAccent,
    ),

    child: new RandomQuoteContainer(),
  );

  final homePageFragment = new DrawerFragment(Icons.home, "Home", "Go back to the home page.", globals.homePageRouteName);
  final syllabusPageFragment = new DrawerFragment(Icons.book, "Syllabus", "Access the syllabus of your subjects.", globals.syllabusPageRouteName);
  final eventsFragment = new DrawerFragment(Icons.notifications, "Events", "View or add reminders for exams/events.", globals.eventsPageRouteName);
  final marksCalculatorFragment = new DrawerFragment(Icons.assessment, "Marks Calculator", "Input your assignment scores, get your final mark. Simple.", globals.marksCalculatorPageRouteName);

  final getProFragment = new DrawerFragment(Icons.card_membership, "Get Pro", "Buy us a cup of chai, we'll help you get rid of ads!", globals.getProPageRouteName);
  final sendFeedbackFragment = new ListTile(
    leading: new Icon(Icons.feedback),
    title: new Text("Send Feedback"),
    subtitle: new Text("Report a nasty bug or send awesome ideas our way."),
    onTap: _launchBugReportingWebsite,
  );
  final settingsFragment = new DrawerFragment(Icons.settings, "Settings", "Configure your app settings.", globals.settingsPageRouteName);

  Widget build(BuildContext context){
    List<Widget> fragmentsList = [drawerHeader, homePageFragment, syllabusPageFragment, eventsFragment, marksCalculatorFragment, new Divider(),
      getProFragment, settingsFragment, sendFeedbackFragment];
    if (usedInHomePage) {
      fragmentsList.remove(homePageFragment);
    }
    // Put the header and all the fragments together in a ListView.
    ListView fragmentListView= new ListView(children: fragmentsList);
    final drawer = new Drawer(child: fragmentListView);
    return drawer;
  }

}
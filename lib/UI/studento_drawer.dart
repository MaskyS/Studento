import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../UI/random_quote_container.dart';

class StudentoDrawer extends StatelessWidget {

  /// Whether this drawer is being used in the HomePage. If so, we'll remove
  /// the fragment that navigates to the HomePage on tap.
  final bool usedInHomePage;

  StudentoDrawer({this.usedInHomePage: false});

  static void _launchBugReportingWebsite() async {
    print("You're a good user, thanks for reporting bugs.");
    const url = 'https://github.com/MaskyS/studento/issues/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open $url. Check your internet connection and try again.';
    }
  }

  final LinearGradient backgroundGradient = LinearGradient(
    begin: FractionalOffset(0.0, 0.0),
    end: FractionalOffset(2.0, 0.0),
    stops: [0.0, 0.5],
    tileMode: TileMode.clamp,
    colors: [
      Colors.deepPurpleAccent,
      Color(0xFF5fbff9), // Imperialish blue.
    ],
  );

  // Place quote and author widgets located in RandomQuotesContainer() into the
  // DrawerHeader.
  drawerHeader() => DrawerHeader(
    decoration: BoxDecoration(
      gradient: backgroundGradient,
    ),
    child: RandomQuoteContainer(),
  );

  final homePageFragment = DrawerFragment(
    title: "Home",
    icon: Icons.home,
    subtitle: "Go back to the home page.",
    routeName: 'home_page',
  );

  final syllabusPageFragment = DrawerFragment(
    icon: Icons.book,
    title: "Syllabus",
    subtitle: "Access the syllabus of your subjects.",
    routeName: 'syllabus_page',
  );

  final eventsFragment = DrawerFragment(
    icon: Icons.notifications,
    title: "Events",
    subtitle: "View or add reminders for exams/events.",
    routeName: 'events_page',
  );

  final marksCalculatorFragment = DrawerFragment(
    icon: Icons.assessment,
    title: "Marks Calculator",
    subtitle: "Input your assignment scores, get your final mark. Simple.",
    routeName: 'marks_calculator_page',
  );

  final getProFragment = DrawerFragment(
    icon: Icons.card_membership,
    title: "Get Pro",
    subtitle: "Buy us a cup of chai, we'll help you get rid of ads!",
    routeName: 'get_pro_page',
  );

  final sendFeedbackFragment = ListTile(
    leading: Icon(Icons.feedback),
    title: Text("Send Feedback"),
    subtitle: Text("Report a nasty bug or send awesome ideas our way."),
    onTap: _launchBugReportingWebsite,
  );

  final settingsFragment = DrawerFragment(
    icon: Icons.settings,
    title: "Settings",
    subtitle: "Configure your app settings.",
    routeName: 'settings_page',
  );

  Widget build(BuildContext context) {
    List<Widget> fragmentsList = [
      drawerHeader(),
      homePageFragment,
      syllabusPageFragment,
      eventsFragment,
      marksCalculatorFragment,
      Divider(),
      getProFragment,
      settingsFragment,
      sendFeedbackFragment
    ];

    if (usedInHomePage) {
      fragmentsList.remove(homePageFragment);
    }

    final drawer = Drawer(
      child: ListView(
        children: fragmentsList,
      )
    );
    return drawer;
  }
}

class DrawerFragment extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String routeName;

  DrawerFragment(
      {@required this.icon,
      @required this.title,
      @required this.subtitle,
      this.routeName,}
  );

  void _onTap(String routeName, BuildContext context) {
    Navigator.pushReplacementNamed(context, 'home_page');
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {

    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: () => _onTap(routeName, context),
    );
  }
}

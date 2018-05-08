import './pages/HomePage.dart';
import './pages/syllabus.dart';
import './pages/EventsPage.dart';
import './pages/MarksCalculatorPage.dart';
import './pages/GetProPage.dart';
import './pages/SettingsPage.dart';
import './pages/SchedulePage.dart';
import 'pages/TodoListPage.dart';
import 'pages/topic_notes.dart';

//TODO This name should be input on first run. For now, it's Romeo.
String userName = "Romeo";

// Initialise these variables so we don't have to import each and every one of
// these  pages each time we want to navigate to them.

final String homePageRouteName = HomePage.routeName;
final String pastPapersPageRouteName = HomePage.routeName;
final String syllabusPageRouteName = SyllabusPage.routeName;
final String eventsPageRouteName = EventsPage.routeName;
final String marksCalculatorPageRouteName = MarksCalculatorPage.routeName;
final String getProPageRouteName = GetProPage.routeName;
final String settingsPageRouteName = SettingsPage.routeName;
final String schedulePageRouteName = SchedulePage.routeName;
final String todoListPageRouteName = TodoListPage.routeName;
final String topicNotesPageRouteName = TopicNotesPage.routeName;
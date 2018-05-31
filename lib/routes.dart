import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/past_papers_page.dart';
import 'pages/syllabus.dart';
import 'pages/events_page.dart';
import 'pages/marks_calculator_page.dart';
import 'pages/get_pro_page.dart';
import 'pages/settings.dart';
import 'pages/schedule_page.dart';
import 'pages/todo_list_page.dart';
import 'pages/topic_notes.dart';

const String homeRoute = 'home_page';

const String pastPapersPageRoute = 'past_papers_page';
const String schedulePageRoute = 'schedule_page';
const String syllabusPageRoute = 'syllabus_page';
const String topicNotesPageRoute = 'topic_notes_page';
const String eventsPageRoute = 'events_page';

const String marksCalculatorPageRoute = 'marks_calculator_page';
const String getProPageRoute = 'get_pro_page';
const String settingsPageRoute = 'settings_page';
const String todoListPageRoute = 'todo_list_page';

Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  homeRoute: (BuildContext context) => HomePage(),
  pastPapersPageRoute: (BuildContext context) => PastPapersPage(),
  schedulePageRoute: (BuildContext context) => SchedulePage(),
  syllabusPageRoute: (BuildContext context) => SyllabusPage(),
  topicNotesPageRoute: (BuildContext context) => TopicNotesPage(),
  eventsPageRoute: (BuildContext context) => EventsPage(),
  marksCalculatorPageRoute: (BuildContext context) => MarksCalculatorPage(),
  getProPageRoute: (BuildContext context) => GetProPage(),
  settingsPageRoute: (BuildContext context) => SettingsPage(),
  todoListPageRoute: (BuildContext context) => TodoListPage(),
};

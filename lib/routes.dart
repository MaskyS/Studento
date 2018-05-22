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
  homeRoute: (BuildContext context) => new HomePage(),
  pastPapersPageRoute: (BuildContext context) => new PastPapersPage(),
  schedulePageRoute: (BuildContext context) => new SchedulePage(),
  syllabusPageRoute: (BuildContext context) => new SyllabusPage(),
  topicNotesPageRoute: (BuildContext context) => new TopicNotesPage(),
  eventsPageRoute: (BuildContext context) => new EventsPage(),
  marksCalculatorPageRoute: (BuildContext context) => new MarksCalculatorPage(),
  getProPageRoute: (BuildContext context) => new GetProPage(),
  settingsPageRoute: (BuildContext context) => new SettingsPage(),
  todoListPageRoute: (BuildContext context) => new TodoListPage(),
};

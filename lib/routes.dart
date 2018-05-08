import 'package:flutter/material.dart';
import 'pages/HomePage.dart';
import 'pages/PastPapersPage.dart';
import 'pages/syllabus.dart';
import 'pages/EventsPage.dart';
import 'pages/MarksCalculatorPage.dart';
import 'pages/GetProPage.dart';
import 'pages/settings.dart';
import 'pages/SchedulePage.dart';
import 'pages/TodoListPage.dart';
import 'pages/topic_notes.dart';

const String homeRoute = '/';

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
  pastPapersPageRoute: (BuildContext context) =>
      new PastPapersPage(),
  schedulePageRoute: (BuildContext context) =>
      new SchedulePage(),
  syllabusPageRoute: (BuildContext context) =>
      new SyllabusPage(),
  topicNotesPageRoute: (BuildContext context) =>
      new TopicNotesPage(),
  eventsPageRoute: (BuildContext context) =>
      new EventsPage(),
  marksCalculatorPageRoute: (BuildContext context) =>
      new MarksCalculatorPage(),
  getProPageRoute: (BuildContext context) =>
      new GetProPage(),
  settingsPageRoute: (BuildContext context) =>
      new SettingsPage(),
  todoListPageRoute: (BuildContext context) =>
      new TodoListPage(),
};
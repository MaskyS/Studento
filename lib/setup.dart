import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
Future<SharedPreferences> _userSettings = SharedPreferences.getInstance();


void setup() async{

  final SharedPreferences userSettings = await _userSettings;
  userSettings.setStringList("subjectsList", ["English", "French", "Mathematics", "Additional Mathematics", "Physics", "Chemistry", "Biology", "Computer Science"]);
  userSettings.setString("level", "O Level");
  userSettings.setString("username", "Romeo");
  for (var item in userSettings.getStringList("subjectsList")) {
    String subject = item;
    userSettings.setStringList("$subject Variants", ["Paper 1", "Paper 2"]);
  }

}
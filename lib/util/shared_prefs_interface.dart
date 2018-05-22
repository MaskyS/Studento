import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPreferencesHelper {
  static Future<bool> getIsFirstRun() async{
   var userData = await SharedPreferences.getInstance();
   bool isFirstRun = userData.getBool("is_first_run");
   return isFirstRun;
  }

  static void setIsFirstRun(bool isFirstRun) async{
    var userData = await SharedPreferences.getInstance();
    userData.setBool("is_first_run", isFirstRun);
  }
  static Future<String> getLevel() async {
    var userData = await SharedPreferences.getInstance();
    String level = userData.getString("level");

    return level;
  }

  static void setLevel(String level) async {
    var userData = await SharedPreferences.getInstance();
    userData.setString("level", level);

    print("level has been set to: $level");
  }

  static void setName(String name) async {
    var userData = await SharedPreferences.getInstance();
    userData.setString("user_name", name);

    print("user_name has been set to: $name");
  }

  static Future<List<String>> getSubjectsList() async{
    var userData = await SharedPreferences.getInstance();
    List<String> subjectsList = userData.getStringList("subjects");

    return subjectsList;
  }

  static void setSubjectsList(List subjectsList) async{
    var userData = await SharedPreferences.getInstance();
    userData.setStringList("subjects", subjectsList);

    print("subjects has been set to $subjectsList");
  }

  static Future<String> getSessionLength() async{
    var userData = await SharedPreferences.getInstance();
    String sessionLength = userData.getString("session_length");

    return sessionLength;
  }

  static void setSessionLength(String sessionLength) async{
    var userData = await SharedPreferences.getInstance();
    userData.setString("session_length", sessionLength);

    print("session_length has been set to: $sessionLength");
  }

  static Future<int> getNoOfSessions() async{
    var userData = await SharedPreferences.getInstance();
    int noOfSessions = userData.getInt("no_of_sessions");

    return noOfSessions;
  }

  static void setNoOfSessions(int noOfSessions) async{
    var userData = await SharedPreferences.getInstance();
    userData.setInt("no_of_sessions", noOfSessions);

    print("session_length has been set to: $noOfSessions");
  }
}

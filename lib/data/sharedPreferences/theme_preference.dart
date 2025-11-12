
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePreference {
  ThemePreference._internal();
  static final ThemePreference _singleton = ThemePreference._internal();
  static ThemePreference get instance => _singleton;

  Future<bool?> getModeState()async{
    SharedPreferences pref = await SharedPreferences.getInstance();

    bool? isDark = pref.getBool("isDarkMode");

    return isDark;
  }

  Future<void> setMode(bool isDark)async{
    SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setBool("isDarkMode", isDark);
  }
}
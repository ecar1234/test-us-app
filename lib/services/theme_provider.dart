
import 'package:flutter/material.dart';

import '../data/sharedPreferences/theme_preference.dart';

class ThemeProvider extends ChangeNotifier {
  ThemePreference get pref => ThemePreference.instance;

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  Future<void> getIsDarkMod()async{
    bool? mode = await pref.getModeState();
    if(mode != null){
      _isDarkMode = mode;
    }else{
      if(ThemeMode.system == ThemeMode.light){
        _isDarkMode = false;
      }else if(ThemeMode.system == ThemeMode.dark) {
        _isDarkMode = true;
      }
    }
    notifyListeners();
  }
  Future<void> changedThemeMode(bool mode)async{
    await pref.setMode(mode);
    _isDarkMode = mode;
    notifyListeners();
  }

}
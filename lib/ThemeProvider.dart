import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {

  bool _isDarkMode = false;

  ThemeProvider(){
    loadTheme();
  }


  bool getThemeValue() => _isDarkMode;

  Future<void> loadTheme() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _isDarkMode = preferences.getBool('isDarkMode') ?? false;
    notifyListeners();
  }


  Future<void> shared({required bool value}) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool('isDarkMode', value);
    _isDarkMode = value;
    notifyListeners();

  }



}
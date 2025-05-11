import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider extends ChangeNotifier{
  bool _isAuthenticate = false;
  bool getIsAuthenticateValue() => _isAuthenticate;


  AuthenticationProvider(){
    loadAuthentication();
  }

  Future<void> loadAuthentication() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _isAuthenticate = preferences.getBool('isAuthenticate') ?? false;
    notifyListeners();
  }


  Future<void> sharedAuthentication({required bool value}) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool('isAuthenticate', value);
    _isAuthenticate = value;
    notifyListeners();
  }
}
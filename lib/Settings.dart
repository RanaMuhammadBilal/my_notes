import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/ThemeProvider.dart';
import 'package:my_notes/data/AuthenticationProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => SettingState();

}
class SettingState extends State<Setting>{

  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Consumer<ThemeProvider>(builder: (_, provider,__) {
            return SwitchListTile.adaptive(
                value: provider.getThemeValue(),
                title: Text('Dark Mode'),
                subtitle: Text('Change Theme Mode Here'),
                onChanged: (value) async{
                  await provider.shared(value: value);
                });
          }),
          Consumer<AuthenticationProvider>(builder: (_, provider,__){
          return SwitchListTile.adaptive(
          value: provider.getIsAuthenticateValue(),
          title: Text('Biometric Verification'),
          subtitle: Text('Change Your Authentication Mode Here'),
          onChanged: (value) async{
          await provider.sharedAuthentication(value: value);
          });
          }),
        ],
      ),
    );
  }

}
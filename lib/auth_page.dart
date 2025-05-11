import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/auth_services.dart';
import 'package:my_notes/main.dart';

class AuthPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => AuthPageState();

}

class AuthPageState extends State<AuthPage>{

  @override
  void initState() {
    super.initState();
    biometric();
  }
  void biometric() async{
    bool check =  await AuthServices().authenticateLocally();
    if(check){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyNotes()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(onPressed: () async{
        }, icon: Icon(Icons.fingerprint, size: 70,)),
      ),
    );
  }

}
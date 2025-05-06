import 'package:flutter/material.dart';
import 'package:my_notes/data/local/db_helper.dart';

class DBProvider extends ChangeNotifier{

  DBHelper dbHelper;
  DBProvider({required this.dbHelper});
  List<Map<String, dynamic>> _notes = [];

  void addNote(String mTitle, String mDesc) async{

     bool check =  await dbHelper.addNote(title: mTitle, content: mDesc);
     if(check){
       _notes = await dbHelper.getAllNotes();
       notifyListeners();
     }

  }

  List<Map<String, dynamic>> getNotes() => _notes;

  void updateNote(String mTitle, String mDesc, int sno) async{
    bool check = await  dbHelper.updateNote(title: mTitle, content: mDesc, colId: sno);
    if(check){
      _notes = await dbHelper.getAllNotes();
      notifyListeners();
    }
  }

  void getInitialNotes() async{
    _notes = await dbHelper.getAllNotes();
    notifyListeners();
  }

  void delNote(int colID) async{
    bool check = await dbHelper.deleteNote(columnId: colID);
    if(check){
      _notes = await dbHelper.getAllNotes();
      notifyListeners();
    }
  }




}
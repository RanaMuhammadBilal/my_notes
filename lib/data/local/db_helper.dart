import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{

  static final String TABLENAME = 'notes';
  static final String COLUMNID = 'id';
  static final String COLUMNTITLE = 'title';
  static final String COLUMNCONTENT = 'content';

  DBHelper._();

  static final DBHelper getInstance = DBHelper._();

  Database? db;



  Future<Database?> getDB() async{
     db ??= await openDB();
     return db;
  }
  Future<Database> openDB() async{
    Directory appDir = await getApplicationDocumentsDirectory();
    String path = join(appDir.path, "notes.db");
    return openDatabase(path, onCreate: (db, version){
      db.execute("create table $TABLENAME($COLUMNID integer primary key autoincrement, $COLUMNTITLE text, $COLUMNCONTENT text)");
    }, version: 1);
  }


  //events


  //add note
  Future< bool> addNote({required String title, required String content}) async{

      var database = await getDB();
      int rowsEffected = await database!.insert(TABLENAME, {
            COLUMNTITLE : title,
            COLUMNCONTENT : content,
          });
      return rowsEffected>0;
  }

  //get all notes
  Future<List<Map<String, dynamic>>> getAllNotes() async{
    var database = await getDB();
    List<Map<String, dynamic>> allNOtes =  await database!.query(TABLENAME);
    return allNOtes;
  }

  //delete note
  Future<bool> deleteNote({required int columnId}) async{
    var database = await getDB();
    int rowsEffected = await database!.delete(TABLENAME, where: "$COLUMNID = $columnId");
    return rowsEffected>0;
  }

  //update note
  Future<bool> updateNote({required String title, required String content, required int colId }) async {
    var database = await getDB();
    int rowsEffected = await database!.update(TABLENAME,{
      COLUMNTITLE : title,
      COLUMNCONTENT : content,
    }, where: "$COLUMNID = ?", whereArgs: [colId]);

    return rowsEffected>0;
  }

}
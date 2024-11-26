import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{

  static final String NOTE_TABLE= "note";
  static final String NOTE_COLUMN_ID= "note_id";
  static final String NOTE_COLUMN_TITLE= "note_title";
  static final String NOTE_COLUMN_DESC="note_desc";




  DBHelper._();

  static DBHelper getInstance=DBHelper._();


  Database? mDB;


  Future<Database> initDB()async{
    mDB=mDB ?? await openDB();
    return mDB!;
  }

  Future<Database> openDB()async{
    var dirPath=await getApplicationDocumentsDirectory();
    var dbPath=join(dirPath.path,"Note.db");
    return openDatabase(dbPath, version: 1, onCreate: (db,version){
      db.execute("create table $NOTE_TABLE ( $NOTE_COLUMN_ID integer primary key autoincrement, $NOTE_COLUMN_TITLE text, $NOTE_COLUMN_DESC text)");
    });
  }

  Future<bool> addNote({required String title,required String desc})async{
    Database db=await initDB();
    int rowsEffected=await db.insert(NOTE_TABLE, {
      NOTE_COLUMN_TITLE: title,
      NOTE_COLUMN_DESC: desc
    });
    return rowsEffected>0;
  }

  Future<List<Map<String,dynamic>>> fetchDB()async{
    Database db=await initDB();
    List<Map<String,dynamic>> allNote=await db.query(NOTE_TABLE);
    return allNote;
  }

  Future<bool> updateDB({required String title,required String desc,required int id})async{
    Database db=await initDB();
    int rowsEffected=await db.update(NOTE_TABLE, {
      NOTE_COLUMN_TITLE:title,
      NOTE_COLUMN_DESC:desc
    },where: "$NOTE_COLUMN_ID=? ", whereArgs: ["$id"]);
    return rowsEffected>0;
  }

  Future<bool> deleteDB({required int id})async{
    Database db=await initDB();
    int rowsEffected=await db.delete(NOTE_TABLE,where: "$NOTE_COLUMN_ID=?",whereArgs: ["$id"]);
    return rowsEffected>0;
  }




}
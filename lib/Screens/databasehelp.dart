import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

import 'package:sqlite/Models/listModel.dart';

class DatabaseHelper{

  late Database _db;
  final ValueNotifier<List<StudentModel>> studentlist=ValueNotifier<List<StudentModel>>([]);

  Future <void> open() async{
   _db= await openDatabase(
    join(await getDatabasesPath(),'student_database.db'),
    onCreate: ((db, version) {
      return db.execute('CREATE TABLE students(id INTEGER PRIMARY KEY, name TEXT , age TEXT)');
    }
    ),
    version:1,
   );
  }

  Future<void> insertStudent(StudentModel student) async{
    await _db.insert('students',student.toMap());
    await getStudents();
    }

  Future<List<StudentModel>> getStudents() async {
  final List<Map<String, dynamic>> map = await _db.query('students');
  return List.generate(map.length, (i) {
  return StudentModel.fromMap(map[i]);});
}
 
}

 
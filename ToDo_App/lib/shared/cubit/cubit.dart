import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

import 'package:login_screen/modules/archive_tasks/archive_tasks_screen.dart';
import 'package:login_screen/modules/done_tasks/done_tasks_screen.dart';
import 'package:login_screen/modules/new_tasks/new_tasks_screen.dart';
import 'package:login_screen/shared/components/constants.dart';
import 'package:login_screen/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppinitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;

  List<Map> new_tasks = [];
  List<Map> archiv_tasks = [];
  List<Map> done_tasks = [];


  List<Widget> screens = [
    New_Tasks_Screen(),
    Done_Tasks_Screen(),
    Archive_Tasks_Screen(),
  ];
  List<String> text = ['New Tasks', 'Done Tasks', 'Archive Tasks'];

  void Changeindex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavigationBar());
  }

  bool isbottomsheetShowen = false;
  IconData ico = Icons.edit;

  void changeBottomsheetstate({
     bool isShow,
     IconData icon,
  }) {
    isbottomsheetShowen = isShow;
    ico = icon;
    emit(AppChangeBottomsheetState());
  }

  // 1- create database
// 2- create tables
// 3- open database
// 4- insert to database
// 5- get from database
// 6- update in database
// 7- delete from database
    Database database;

  void createDatabase() {
    openDatabase(
      'mydata.db',
      version: 1,
      onCreate: (database, version) async {
        print('database is created');
        await database
            .execute(
                'CREATE TABLE mytasks(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT, date TEXT,time TEXT,status TEXT)')
            .then((value) {
          print('table is created');
        }).catchError((error) {
          print('your Error is ${error.toString()}');
        });

      },
      onOpen: (database) {
        print('Database is Opened');

      },
    ).then((value) {
      database = value;
      emit(AppCreatedatabaseState());
    });
  }

    insertToDatabase({
       title,
       date,
       time,
    }) {
      database.transaction((txn) {
        txn
            .rawInsert(
                'INSERT INTO mytasks(title,date,time,status) VALUES("$title","$date","$time","new")')
            .then((value) {
          print('Data inserted Successfully');
          print(value);
          emit(AppInsertdatabaseState());
          getData(database);
        }).catchError((error) {
          print('the Error is ${error.toString()}');
        });

        return null;
      });
    }























  void getData(database) {
    new_tasks = [];
    done_tasks = [];
    archiv_tasks = [];

    database.rawQuery('SELECT * FROM mytasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          new_tasks.add(element);
        } else if (element['status'] == 'done') {
          done_tasks.add(element);
        } else
          archiv_tasks.add(element);
      });

      emit(AppGetdatabaseState());
    });
  }


  void updatedata({
     String status,
     int id,
  }) {
    database.rawUpdate('UPDATE mytasks SET status = ? WHERE id=?',
        ['$status', id]).then((value) {
      getData(database);
      emit(AppupdatedatabaseState());
    });
  }

  void deletedata({
     int id,
  }) {
    database.rawUpdate('DELETE FROM mytasks WHERE id = ?', [id]).then((value) {
      getData(database);
      emit(AppDeletedatabaseState());
    });
  }
}

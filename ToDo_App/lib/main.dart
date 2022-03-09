import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_screen/shared/bloc_observer.dart';

import 'layout/TodoApp/home_layout.dart';


void main() {
  Bloc.observer = MyBlocObserver();

  runApp(MaterialApp(
    home: Home_layout(),
  ));
}

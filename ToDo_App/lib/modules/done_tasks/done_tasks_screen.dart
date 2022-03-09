import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_screen/shared/components/componants.dart';
import 'package:login_screen/shared/cubit/cubit.dart';
import 'package:login_screen/shared/cubit/states.dart';

// ignore: camel_case_types
class Done_Tasks_Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).done_tasks;
        return showdata(tasks: tasks);
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_screen/shared/components/componants.dart';
import 'package:login_screen/shared/cubit/cubit.dart';
import 'package:login_screen/shared/cubit/states.dart';
import 'package:intl/intl.dart';

// ignore: camel_case_types
class Home_layout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titlecontroller = TextEditingController();
  var timecontroller = TextEditingController();
  var datecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => AppCubit()..createDatabase(),
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (BuildContext context, AppStates state) {
            if (state is AppInsertdatabaseState) Navigator.pop(context);
          },
          builder: (BuildContext context, AppStates state) {
            AppCubit cubit = AppCubit.get(context);
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text(cubit.text[cubit.currentIndex]),
              ),
              body: cubit.screens[cubit.currentIndex],
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.isbottomsheetShowen) {
                    if (formKey.currentState.validate()) {
                      cubit.insertToDatabase(
                          title: titlecontroller.text,
                          date: datecontroller.text,
                          time: timecontroller.text);

                      cubit.changeBottomsheetstate(
                          isShow: true, icon: Icons.edit);
                    }
                  } else {
                    scaffoldKey.currentState
                        .showBottomSheet(
                            (context) => Container(
                                  width: double.infinity,
                                  color: Colors.grey[100],
                                  padding: EdgeInsets.all(20),
                                  child: Form(
                                    key: formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        //title text
                                        Container(
                                          child: defultTextFormFaild(
                                              controlle: titlecontroller,
                                              tybe: TextInputType.text,
                                              lable: 'Title',
                                              prefix: Icons.title,
                                              validate: (String value) {
                                                if (value.isEmpty) {
                                                  return 'the title must not empty';
                                                }
                                                return null;
                                              }),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        //time text
                                        Container(
                                          child: defultTextFormFaild(
                                              controlle: timecontroller,
                                              tybe: TextInputType.datetime,
                                              lable: 'Time',
                                              prefix:
                                                  Icons.watch_later_outlined,
                                              validate: (String value) {
                                                if (value.isEmpty) {
                                                  return 'the Time must not empty';
                                                }
                                                return null;
                                              },
                                              onTap: () {
                                                showTimePicker(
                                                        context: context,
                                                        initialTime:
                                                            TimeOfDay.now())
                                                    .then((value) {
                                                  timecontroller.text = value
                                                      .format(context)
                                                      .toString();
                                                }).catchError((error) {
                                                  print('Your Error is $error');
                                                });
                                              }),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        //date text
                                        Container(
                                          child: defultTextFormFaild(
                                              controlle: datecontroller,
                                              tybe: TextInputType.datetime,
                                              lable: 'Date',
                                              prefix:
                                                  Icons.calendar_today_outlined,
                                              validate: (String value) {
                                                if (value.isEmpty) {
                                                  return 'the Date must not empty';
                                                }
                                                return null;
                                              },
                                              onTap: () {
                                                showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate:
                                                            DateTime.now(),
                                                        lastDate:
                                                            DateTime.parse(
                                                                "2021-10-07"))
                                                    .then((value) {
                                                  datecontroller.text =
                                                      DateFormat.yMMMd()
                                                          .format(value);
                                                }).catchError((error) {
                                                  print('the Error is $error');
                                                });
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            elevation: 20.0)
                        .closed
                        .then((value) {
                      cubit.changeBottomsheetstate(
                          isShow: false, icon: Icons.edit);
                    });

                    cubit.changeBottomsheetstate(isShow: true, icon: Icons.add);
                  }
                },
                child: Icon(cubit.ico),
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.Changeindex(index);
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu), label: 'Tasks'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle_outline), label: 'Done'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined), label: 'Archived'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), label: 'User'),
                ],
              ),
            );
          },
        ));
  }
}

// @dart=2.9
import 'package:flutter/material.dart';
import 'package:login_screen/shared/cubit/cubit.dart';

Widget buildButton({
  double width = double.infinity,
  Color color = Colors.blue,
  bool isUppercase = true,
  double radiuss = 20.0,
  Function onpressed,
  String text,
}) =>
    Container(
      width: width,
      child: MaterialButton(
        onPressed: onpressed,
        child: Text(
          isUppercase ? text.toUpperCase() : text.toLowerCase(),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radiuss),
        color: color,
      ),
    );

Widget defultTextFormFaild({
  TextEditingController controlle,
  TextInputType tybe,
  String lable,
  IconData prefix,
  Function validate,
  IconData sufix,
  bool ispassowrd = false,
  Function onchange,
  Function onsubmit,
  Function hideen,
  Function onTap,
}) {
  return TextFormField(
    onChanged: onchange,
    onTap: onTap,
    onFieldSubmitted: onsubmit,
    validator: validate,
    controller: controlle,
    keyboardType: tybe,
    obscureText: ispassowrd,
    decoration: InputDecoration(
      labelText: lable,
      border: OutlineInputBorder(),
      prefixIcon: Icon(prefix),
      suffixIcon: sufix != null
          ? IconButton(
              icon: Icon(sufix),
              onPressed: hideen,
            )
          : null,
    ),
  );
}

Widget rowItemes(Map model, context) {
  return Dismissible(
    key: Key(model['id'].toString()),
    onDismissed: (direction) {
      AppCubit.get(context).deletedata(id: model['id']);
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text('${model['time']}'),
            radius: 40,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model['title']}',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '${model['date']}',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          IconButton(
              icon: Icon(
                Icons.check_box,
                color: Colors.green,
              ),
              onPressed: () {
                AppCubit.get(context)
                    .updatedata(status: 'done', id: model['id']);
              }),
          IconButton(
              icon: Icon(Icons.archive, color: Colors.grey),
              onPressed: () {
                AppCubit.get(context)
                    .updatedata(status: 'archiv', id: model['id']);
              })
        ],
      ),
    ),
  );
}

Widget showdata({tasks}) {
  if (tasks.length > 0) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return rowItemes(tasks[index], context);
        },
        separatorBuilder: (context, index) {
          return Container(
            height: 0.0,
            width: double.infinity,
          );
        },
        itemCount: tasks.length);
  } else {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          color: Colors.grey,
          size: 150.0,
        ),
        Text(
          'No data here!',
          style: TextStyle(
              color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 20),
        )
      ],
    ));
  }
}

Widget buildArticalItem(list, context) => Padding(
      padding: EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            width: 120.0,
            height: 120.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                    image: list['urlToImage'] == null
                        ? NetworkImage(
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Solid_white.svg/2048px-Solid_white.svg.png')
                        : NetworkImage('${list['urlToImage']}'),
                    fit: BoxFit.cover)),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
              child: Container(
            height: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    ' ${list['title']}',
                    style: Theme.of(context).textTheme.bodyText1,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '${list['publishedAt']}',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ))
        ],
      ),
    );

Widget articalBuilder(list) {
  if (list.length > 0) {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) => buildArticalItem(list[index], context),
        separatorBuilder: (context, index) {
          return Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey[300],
          );
        },
        itemCount: list.length // cubit.business.length
        );
  } else {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

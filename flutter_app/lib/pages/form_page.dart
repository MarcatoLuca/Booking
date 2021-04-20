import 'package:flutter/material.dart';

import 'package:booking/data/app_database.dart';

class FormPage extends StatefulWidget {
  final AppDatabase appDatabase;

  const FormPage({Key key, this.appDatabase}) : super(key: key);

  @override
  _FormPage createState() => _FormPage();
}

enum StateForm { LOGIN, SIGNUP }

class _FormPage extends State<FormPage> {
  List<Widget> form = [
    Card(
      child: ListTile(
        title: Text(
          'Email',
          style: TextStyle(color: Colors.blue),
        ),
        subtitle: TextField(),
        isThreeLine: true,
      ),
    ),
    Card(
      child: ListTile(
        title: Text(
          'Password',
          style: TextStyle(color: Colors.blue),
        ),
        subtitle: TextField(),
        isThreeLine: true,
      ),
    )
  ];

  updateForm() {
    if (form.length == 2) {
      form.add(
        ListTile(
          title: Text(
            'Password (Again)',
            style: TextStyle(color: Colors.blue),
          ),
          subtitle: TextField(),
          isThreeLine: true,
        ),
      );
    } else {
      form.removeAt(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Flexible(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(6),
                  child: Column(
                    children: form,
                  ),
                ),
              ],
            ),
          ),
          Container(
              height: 150,
              child: Center(
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          updateForm();
                        });
                      },
                      child: Text("a")))),
        ],
      ),
    );
  }
}

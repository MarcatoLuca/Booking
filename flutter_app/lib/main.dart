import 'package:flutter/material.dart';

import 'package:booking/app.dart';

import 'package:booking/data/app_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Floor Database Instance
  final appDatabase =
      await $FloorAppDatabase.databaseBuilder('database.db').build();

  runApp(MyApp(appDatabase: appDatabase));
}

class MyApp extends StatelessWidget {
  final AppDatabase appDatabase;

  const MyApp({Key key, this.appDatabase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booking',
      home: Scaffold(body: Center(child: App(appDatabase: appDatabase))),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:booking/app.dart';

import 'package:booking/data/db/app_database.dart';

import 'package:booking/data/server_socket.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDatabase =
      await $FloorAppDatabase.databaseBuilder('database.db').build();
  final ServerSocket socket = new ServerSocket();

  runApp(MyApp(appDatabase: appDatabase, socket: socket));
}

class MyApp extends StatelessWidget {
  final AppDatabase appDatabase;
  final ServerSocket socket;

  const MyApp({Key key, this.appDatabase, this.socket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
          body: Center(
              child: App(
        appDatabase: appDatabase,
        socket: socket,
      ))),
    );
  }
}

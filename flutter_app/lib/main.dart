import 'package:flutter/material.dart';

import 'package:booking/routes/app.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booking',
      home: App(),
    );
  }
}

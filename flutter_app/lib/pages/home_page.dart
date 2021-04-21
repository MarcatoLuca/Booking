import 'package:flutter/material.dart';

import 'package:booking/data/db/app_database.dart';

class HomePage extends StatelessWidget {
  final AppDatabase appDatabase;

  const HomePage({Key key, this.appDatabase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("nihao"),
      ),
    );
  }
}

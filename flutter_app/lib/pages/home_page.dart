import 'package:booking/cubit/user/user_cubit.dart';
import 'package:booking/data/server_socket.dart';
import 'package:booking/pages/home_page_tabs/calendar_tab.dart';
import 'package:booking/pages/home_page_tabs/home_tab.dart';
import 'package:flutter/material.dart';

import 'package:booking/data/db/app_database.dart';

class HomePage extends StatelessWidget {
  final AppDatabase appDatabase;
  final ServerSocket socket;
  final UserCubit userCubit;

  const HomePage({Key key, this.appDatabase, this.socket, this.userCubit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.calendar_today)),
            ],
          ),
          title: Text('Class Dealer'),
        ),
        body: TabBarView(
          children: [
            HomeTab(),
            CalendarTab(),
          ],
        ),
      ),
    );
  }
}

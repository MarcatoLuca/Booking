import 'package:booking/pages/home_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:booking/pages/form_page.dart';

import 'package:booking/data/db/app_database.dart';

import 'package:booking/cubit/user_repository.dart';
import 'package:booking/cubit/user/user_cubit.dart';

import 'data/server_socket.dart';

class App extends StatelessWidget {
  static const MAIN_USER = 1;

  final AppDatabase appDatabase;
  final ServerSocket socket;

  const App({Key key, this.appDatabase, this.socket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserCubit>(
      create: (context) => UserCubit(MainUserRepository()),
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          final userCubit = BlocProvider.of<UserCubit>(context);
          if (state is UserNotConnected) {
            return Text(state.message);
          } else if (state is UserLoading) {
            return CircularProgressIndicator();
          } else if (state is UserAuthenticated) {
            return HomePage();
          } else if (state is UserNotAuthenicated) {
            return FormPage(
                appDatabase: appDatabase, socket: socket, userCubit: userCubit);
          } else {
            userCubit.initialize(MAIN_USER, appDatabase, socket);
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

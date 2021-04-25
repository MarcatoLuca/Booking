import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:booking/app.dart';

import 'package:meta/meta.dart';

import 'package:booking/cubit/user_repository.dart';

import 'package:booking/data/server_socket.dart';

import 'package:booking/data/db/app_database.dart';

import 'package:booking/data/model/user.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _userRepository;

  UserCubit(this._userRepository) : super(UserInitial());

  Future<void> initialize(int id, AppDatabase db, ServerSocket socket) async {
    emit(UserLoading());
    try {
      socket.connect().whenComplete(() async {
        final User user = await _userRepository.getUserCredentail(id, db);
        print(user);
        if (user != null) {
          emit(UserAuthenticated(user));
        } else {
          emit(UserNotAuthenicated("User Not Authenicated"));
        }
      });
    } on SocketException catch (e) {
      emit(UserNotConnected('$e'));
    }
  }

  Future<void> tryLogin(AppDatabase appDatabase, User user) async {
    emit(UserLoading());

    user.id = App.MAIN_USER;
    if (user.isNotNull()) {
      await appDatabase.userDao.insertUser(user);
      emit(UserAuthenticated(user));
    } else {
      emit(UserNotAuthenicated("This User Already Exist"));
    }
  }

  Future<void> logout(AppDatabase appDatabase, User user) async {
    emit(UserLoading());
    await appDatabase.userDao.deleteUser(user);
    emit(UserNotAuthenicated("Login To Access"));
  }
}

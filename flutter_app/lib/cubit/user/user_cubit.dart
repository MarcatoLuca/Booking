import 'dart:io';

import 'package:bloc/bloc.dart';

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
        if (user != null) {
          emit(UserNotAuthenicated("User Not Authenicated"));
        } else {
          emit(UserNotAuthenicated("User Not Authenicated"));
        }
      });
    } on SocketException catch (e) {
      emit(UserNotConnected('$e'));
    }
  }

  void tryLogin(ServerSocket socket, AppDatabase appDatabase, User user) async {
    emit(UserLoading());
    await Future.delayed(Duration(seconds: 2)).whenComplete(() async {
      String status = socket.messages.last.msg;
      if (status == "OK") {
        if (socket.messages.last.code == 1) {
          await appDatabase.userDao.insertUser(user);
        } else if (socket.messages.last.code == 2) {
          await appDatabase.userDao
              .insertUser(new User.fromJson(socket.messages.last.data));
        }
        emit(UserAuthenticated(user));
      } else if (status == "ERROR") {
        emit(UserNotAuthenicated("This User Already Exist"));
      }
    });
  }
}

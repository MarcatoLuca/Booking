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
          emit(UserAuthenticated(user));
        } else {
          emit(UserNotAuthenicated("User Not Authenicated"));
        }
      });
    } on SocketException catch (e) {
      emit(UserNotConnected('$e'));
    }
  }
}

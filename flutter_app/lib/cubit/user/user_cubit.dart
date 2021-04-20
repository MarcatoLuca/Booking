import 'package:bloc/bloc.dart';
import 'package:booking/cubit/user_repository.dart';
import 'package:booking/data/app_database.dart';
import 'package:booking/data/model/user.dart';
import 'package:meta/meta.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _userRepository;

  UserCubit(this._userRepository) : super(UserInitial());

  Future<void> checkUserCredential(int id, AppDatabase db) async {
    emit(UserLoading());
    final User user = await _userRepository.getUserCredentail(id, db);
    if (user != null) {
      emit(UserAuthenticated(user));
    } else {
      emit(UserNotAuthenicated("User Not Authenicated"));
    }
  }
}

import 'package:booking/data/db/app_database.dart';

import 'package:booking/data/model/user.dart';

abstract class UserRepository {
  Future<User> getUserCredentail(int id, AppDatabase db);
}

class MainUserRepository implements UserRepository {
  @override
  Future<User> getUserCredentail(int id, AppDatabase db) async {
    return Future.delayed(Duration(seconds: 1), () {
      return db.userDao.getUser(id);
    });
  }
}

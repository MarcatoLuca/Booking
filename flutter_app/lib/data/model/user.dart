import 'package:floor/floor.dart';

import 'package:crypt/crypt.dart';

import 'package:booking/cubit/user/user_cubit.dart';

import 'package:booking/data/db/app_database.dart';

import 'package:booking/data/server_socket.dart';

@Entity(tableName: 'user')
class User {
  @PrimaryKey(autoGenerate: false)
  final int id;
  String email;
  String password;
  String type;

  User({int id, String type, String email, String password, bool keepMeLogged})
      : id = id,
        type = type,
        email = email,
        password = password;

  Map<String, dynamic> toMap() => {
        "email": this.email,
        "password": this.password,
        "type": this.type,
      };

  factory User.fromJson(Map<String, dynamic> json) => new User(
        id: json["id"],
        email: json["email"],
        password: json["password"],
        type: json["type"],
      );

  bool isNotNull() {
    return this.id != null &&
        this.type != null &&
        this.email != null &&
        this.password != null;
  }

  bool isValid() {
    return _isEmailValid();
  }

  void crypt(String plainPassowrd) {
    this.password = Crypt.sha256(plainPassowrd).toString();
  }

  bool _isEmailValid() {
    return !RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@itiszuccante.edu.it$")
        .hasMatch(this.email);
  }

  void save(
      ServerSocket socket, AppDatabase appDatabase, UserCubit userCubit) async {
    this.type = "USER";
    socket.send(this.toMap(), 1);
    userCubit.tryLogin(socket, appDatabase, this);
  }

  void login(
      ServerSocket socket, AppDatabase appDatabase, UserCubit userCubit) {
    socket.send(this.toMap(), 2);
    userCubit.tryLogin(socket, appDatabase, this);
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, password: $password, type: $type)';
  }
}

@dao
abstract class UserDao {
  @Query('SELECT * FROM user WHERE user.id = :id')
  Future<User> getUser(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertUser(User user);
}

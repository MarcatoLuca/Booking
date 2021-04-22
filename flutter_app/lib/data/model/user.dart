import 'package:booking/data/server_socket.dart';
import 'package:crypt/crypt.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'user')
class User {
  @PrimaryKey(autoGenerate: true)
  final int id;
  int permits;
  String email;
  String password;
  bool keepMeLogged;

  User({int id, int permits, String email, String password, bool keepMeLogged})
      : id = id,
        permits = permits,
        email = email,
        password = password,
        keepMeLogged = keepMeLogged;

  Map<String, dynamic> toMap() => {
        "email": this.email,
        "permits": this.permits,
        "password": this.password,
        "keepMeLogged": this.keepMeLogged,
      };

  factory User.fromJson(Map<String, dynamic> json) => new User(
        id: json["id"],
        permits: json["permits"],
        email: json["email"],
        password: json["password"],
        keepMeLogged: json["keepMeLogged"],
      );

  bool isNotNull() {
    return this.id != null &&
        this.permits != null &&
        this.email != null &&
        this.password != null &&
        this.keepMeLogged != null;
  }

  bool isValid() {
    return _isEmailValid();
  }

  void crypt(String plainPassowrd) {
    this.password = Crypt.sha256(plainPassowrd).toString();
  }

  bool _isEmailValid() {
    return !RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@itiszuccante.edu.it")
        .hasMatch(this.email);
  }

  void save(ServerSocket socket) {}

  void login(ServerSocket socket) {}

  @override
  String toString() {
    return 'User(id: $id, permits: $permits, email: $email, password: $password, keepMeLogged: $keepMeLogged)';
  }
}

@dao
abstract class UserDao {
  @Query('SELECT * FROM user WHERE user.id = :id')
  Future<User> getUser(int id);
}

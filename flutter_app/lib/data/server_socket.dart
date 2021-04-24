import 'dart:convert';
import 'dart:io';

import 'package:booking/data/model/user.dart';

class ServerSocket {
  Socket _socket;
  List<Package> messages = [];

  Future<Socket> connect() {
    return Socket.connect("192.168.1.55", 8080).then((Socket sock) {
      this._socket = sock;
      _socket.listen(_dataHandler,
          onError: _errorHandler, onDone: _doneHandler, cancelOnError: false);
    }).catchError((Object e) {
      throw SocketException("Socket connection failed");
    });
  }

  void _dataHandler(data) {
    print(String.fromCharCodes(data));
    Package package = Package.fromJson(String.fromCharCodes(data));

    switch (package.code) {
      case 1:
        {
          messages.add(package);
          break;
        }
      case 2:
        {
          messages.add(package);
          break;
        }
    }
  }

  void _errorHandler(error, StackTrace trace) {}

  void _doneHandler() {
    _socket.destroy();
  }

  Future<User> saveOrLogin(Map<String, dynamic> data, int code) async {
    User user;
    await Socket.connect("192.168.1.55", 8080).then((Socket sock) async {
      sock.write(Package(code, data, "").toJson());
      await sock.listen((data) {
        Package package = Package.fromJson(String.fromCharCodes(data));
        sock.destroy();
        user = new User.fromJson(package.data);
      }).asFuture();
    });
    return user;
  }
}

/// Code :
/// 0 - server <--> database
/// 1 - user signup
/// 2 - user login
class Package {
  int code;
  Map<String, dynamic> data;
  String msg;

  Package(this.code, this.data, this.msg);

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'data': data,
      'msg': msg,
    };
  }

  factory Package.fromMap(Map<String, dynamic> map) {
    return Package(
      map['code'],
      Map<String, dynamic>.from(map['data']),
      map['msg'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Package.fromJson(String source) =>
      Package.fromMap(json.decode(source));
}

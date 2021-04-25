import 'dart:convert';
import 'dart:io';

import 'package:booking/data/model/class.dart';
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

  Future<User> saveAndLogin(List<Map<String, dynamic>> data, int code) async {
    User user = new User();
    await Socket.connect("192.168.1.55", 8080).then((Socket sock) async {
      sock.write(Package(code: code, data: data, msg: "").toJson());
      await sock.listen((data) {
        Package package = Package.fromJson(String.fromCharCodes(data));
        sock.destroy();
        if (package.data.first != null) {
          user = new User.fromJson(package.data.first);
        }
      }).asFuture();
    });
    return user;
  }

  Future<List<Class>> getClass() async {
    List<Class> data = [];
    await Socket.connect("192.168.1.55", 8080).then((Socket sock) async {
      sock.write(Package(code: 3, data: [], msg: "").toJson());
      await sock.listen((data) {
        Package package = Package.fromJson(String.fromCharCodes(data));
        sock.destroy();
        //package.data
      }).asFuture();
    });
  }
}

/// Code :
/// 0 - server <--> database
/// 1 - user signup
/// 2 - user login
/// 3 - class
class Package {
  int code;
  List<Map<String, dynamic>> data;
  String msg;

  Package({int code, List<Map<String, dynamic>> data, String msg})
      : code = code,
        data = data,
        msg = msg;

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'data': data,
      'msg': msg,
    };
  }

  factory Package.fromMap(Map<String, dynamic> map) {
    return Package(
      code: map['code'],
      data: List<Map<String, dynamic>>.from(map['data']),
      msg: map['msg'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Package.fromJson(String source) =>
      Package.fromMap(json.decode(source));
}

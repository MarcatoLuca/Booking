import 'dart:convert';
import 'dart:io';

import 'package:booking/app.dart';
import 'package:booking/data/db/app_database.dart';
import 'package:booking/data/model/class.dart';
import 'package:booking/data/model/prenotation.dart';
import 'package:booking/data/model/user.dart';

class ServerSocket {
  Socket _socket;

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
    Package package = Package.fromJson(String.fromCharCodes(data));

    switch (package.code) {
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

  Future<List<Class>> saveAndGetClasses(AppDatabase appDatabase) async {
    List<Class> datas = [];
    await Socket.connect("192.168.1.55", 8080).then((Socket sock) async {
      sock.write(Package(code: 3, data: [], msg: "").toJson());
      await sock.listen((data) {
        Package package = Package.fromJson(String.fromCharCodes(data));
        sock.destroy();
        if (package.data != null) {
          package.data.forEach((element) async {
            Class classRoom = new Class.fromJson(element);
            datas.add(classRoom);

            await appDatabase.classDao.insertClass(classRoom);
          });
        }
      }).asFuture();
    });
    return datas;
  }

  Future<void> getAllPrenotation(AppDatabase appDatabase) async {
    await Socket.connect("192.168.1.55", 8080).then((Socket sock) async {
      sock.write(Package(code: 4, data: [], msg: "").toJson());
      await sock.listen((data) {
        Package package = Package.fromJson(String.fromCharCodes(data));
        sock.destroy();
        if (package.data != null) {
          package.data.forEach((element) async {
            await appDatabase.prenotationDao
                .insertPrenotation(new Prenotation.fromJson(element));
          });
        }
      }).asFuture();
    });
  }

  Future<List<Prenotation>> getMyPrenotation(int userId) async {
    List<Prenotation> datas = [];
    await Socket.connect("192.168.1.55", 8080).then((Socket sock) async {
      sock.write(Package(code: 4, data: [], msg: "").toJson());
      await sock.listen((data) {
        Package package = Package.fromJson(String.fromCharCodes(data));
        sock.destroy();
        if (package.data != null) {
          package.data.forEach((element) {
            Prenotation prenotation = new Prenotation.fromJson(element);
            if (prenotation.userId == userId) {
              datas.add(prenotation);
            }
          });
        }
      }).asFuture();
    });
    return datas;
  }

  Future<void> savePrenotation(
      List<Map<String, dynamic>> data, AppDatabase appDatabase) async {
    await Socket.connect("192.168.1.55", 8080).then((Socket sock) async {
      sock.write(Package(code: 5, data: data, msg: "").toJson());
      await sock.listen((data) async {
        Package package = Package.fromJson(String.fromCharCodes(data));
        sock.destroy();
        if (package.data.first != null) {
          await appDatabase.prenotationDao
              .insertPrenotation(new Prenotation.fromJson(package.data.first));
        }
      }).asFuture();
    });
  }

  Future<void> deletePrenotation(
      List<Map<String, dynamic>> data, AppDatabase appDatabase, int id) async {
    await Socket.connect("192.168.1.55", 8080).then((Socket sock) async {
      sock.write(Package(code: 6, data: data, msg: id.toString()).toJson());
      sock.destroy();
    });
  }
}

/// Code :
/// 0 - server dart <--> databaseHttp
/// 1 - user signup
/// 2 - user login
/// 3 - classes
/// 4 - prenotations GET
/// 5 - prenotation POST
/// 6 - prenotation DELETE
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

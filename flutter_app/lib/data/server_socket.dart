import 'dart:convert';
import 'dart:io';

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

  void _dataHandler(data) {}

  void _errorHandler(error, StackTrace trace) {}

  void _doneHandler() {
    _socket.destroy();
  }

  void send(Map<String, dynamic> data, int code) {
    _socket.write(new Package(code, data).toJson());
  }
}

/// Code :
/// 1 - user signup
class Package {
  int code;
  Map<String, dynamic> data;

  Package(this.code, this.data);

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'data': data,
    };
  }

  factory Package.fromMap(Map<String, dynamic> map) {
    return Package(
      map['code'],
      Map<String, dynamic>.from(map['data']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Package.fromJson(String source) =>
      Package.fromMap(json.decode(source));
}

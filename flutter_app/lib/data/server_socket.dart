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
}

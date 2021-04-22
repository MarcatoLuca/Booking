import 'dart:convert';
import 'dart:io';

List<Client> clients = [];

void main() {
  ServerSocket server;
  ServerSocket.bind(InternetAddress.anyIPv4, 8080).then((ServerSocket socket) {
    server = socket;
    server.listen((client) {
      handleConnection(client);
    });
  });
}

void handleConnection(Socket client) {
  clients.add(Client(socket: client));
  print("Connected: " +
      client.address.toString() +
      ", port(" +
      client.port.toString() +
      ")");
}

void removeClient(Client client) {
  clients.remove(client);
}

class Client {
  late Socket socket;
  String get address => socket.remoteAddress.address;
  int get port => socket.remotePort;
  final database = HttpClient();

  Client({required Socket socket}) {
    socket = socket;
    socket.listen(clientHandler,
        onError: errorHandler, onDone: finishedHandler);
  }

  void clientHandler(data) {
    Package package = Package.fromJson(String.fromCharCodes(data));

    switch (package.code) {
      case 1:
        {
          //database.post(host, port, path)
        }
    }
  }

  void errorHandler(error) {}

  void finishedHandler() {}
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

class Http {}

import 'dart:io';

import 'database_http.dart';
import 'package.dart';

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
  DatabaseHttp http = new DatabaseHttp();

  Client({required Socket socket}) {
    this.socket = socket;
    socket.listen(clientHandler,
        onError: errorHandler, onDone: finishedHandler);
  }

  void clientHandler(data) async {
    Package package = Package.fromJson(String.fromCharCodes(data));

    switch (package.code) {
      case 1:
        {
          List<Package> response = await http.getUsers();

          bool userAlreadyExist = response
              .where((element) =>
                  element.data.containsValue(package.data["email"]))
              .isNotEmpty;

          if (!userAlreadyExist) {
            await http.postUser(package);
            this.socket.write(new Package(1, package.data, "OK").toJson());
          } else {
            this.socket.write(
                new Package(1, new Map<String, dynamic>(), "ERROR").toJson());
          }
          break;
        }
      case 2:
        {
          print(package.data.toString());
          await http.updateUser(package.data);
          List<Package> response = await http.getUsers();
          bool userAlreadyExist = response
              .where((element) =>
                  element.data.containsValue(package.data["email"]))
              .isNotEmpty;

          if (userAlreadyExist) {
            this.socket.write(new Package(
                    2,
                    response
                        .where((element) =>
                            element.data.containsValue(package.data["email"]))
                        .single
                        .data,
                    "OK")
                .toJson());
          } else {
            this.socket.write(
                new Package(2, new Map<String, dynamic>(), "ERROR").toJson());
          }
          break;
        }
    }
  }

  void errorHandler(error) {}

  void finishedHandler() {
    print("Closed");
  }
}

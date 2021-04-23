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
    socket = socket;
    socket.listen(clientHandler,
        onError: errorHandler, onDone: finishedHandler);
  }

  void clientHandler(data) async {
    Package package = Package.fromJson(String.fromCharCodes(data));

    switch (package.code) {
      case 1:
        {
          List<Package> response = await http.getUsers();
          bool stop = false;
          response.forEach((element) {
            stop = element.data.containsValue(package.data[
                "email"]); // sistemare stop che prende solo il valore dell ultimo controllo fatto
          });

          if (!stop) await http.postUser(package);
        }
    }
  }

  void errorHandler(error) {}

  void finishedHandler() {}
}

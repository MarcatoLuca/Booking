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
  print("Connected: " +
      client.address.toString() +
      ", port(" +
      client.port.toString() +
      ")");
  clients.add(Client(client));
}

void removeClient(Client client) {
  clients.remove(client);
}

class Client {
  final Socket socket;
  String get address => socket.remoteAddress.address;
  int get port => socket.remotePort;

  Client(this.socket);
}

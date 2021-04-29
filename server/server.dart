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
          //Controllo se l utente esiste già
          Package response = await http.getUsers();
          bool userAlreadyExist = response.data
              .where((element) =>
                  element.containsValue(package.data.first["email"]))
              .isNotEmpty;

          if (!userAlreadyExist) {
            //Aggiungo l utente al database se non esiste
            await http.postUser(package);

            //Prelevo dal database l'utente inserito per ottenere l id remoto
            Package response = await http.getUsers();
            List<Map<String, dynamic>> data = [];
            data.add(response.data
                .where((element) =>
                    element.containsValue(package.data.first["email"]))
                .first);
            this.socket.write(new Package(1, data, "OK").toJson());
          } else {
            //Se già esiste ritorno un errore
            this.socket.write(new Package(1, [], "ERROR").toJson());
          }
          break;
        }
      case 2:
        {
          //Controllo se l utente esiste già
          Package response = await http.getUsers();
          bool userAlreadyExist = response.data
              .where((element) =>
                  element.containsValue(package.data.first["email"]))
              .isNotEmpty;

          if (userAlreadyExist) {
            //Se esiste ritorno l'utente
            List<Map<String, dynamic>> data = [];
            data.add(response.data
                .where((element) =>
                    element.containsValue(package.data.first["email"]))
                .first);
            this.socket.write(new Package(2, data, "OK").toJson());
          } else {
            //Se non esiste esiste ritorno un errore
            this.socket.write(new Package(2, [], "ERROR").toJson());
          }
          break;
        }
      case 3:
        {
          Package response = await http.getClasses();
          //Ritorno le classi presenti nel db
          this.socket.write(new Package(3, response.data, "OK").toJson());
          break;
        }
      case 4:
        {
          Package response = await http.getPrenotations();
          //Ritorno le prenotazioni di tutte le aule prenotate
          this.socket.write(new Package(4, response.data, "OK").toJson());
          break;
        }
      case 5:
        {
          Package response = await http.savePrenotation(package);
          //Ritorno le prenotazioni di tutte le aule prenotate
          this.socket.write(new Package(4, response.data, "OK").toJson());
          break;
        }
      case 6:
        {
          await http.deletePrenotation(package);
          //Ritorno le prenotazioni di tutte le aule prenotate
          break;
        }
    }
  }

  void errorHandler(error) {}

  void finishedHandler() {
    print("Closed");
  }
}

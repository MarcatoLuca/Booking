import 'package:booking/app.dart';
import 'package:booking/data/db/app_database.dart';
import 'package:booking/data/model/class.dart';
import 'package:booking/data/model/prenotation.dart';
import 'package:booking/data/model/user.dart';
import 'package:booking/data/server_socket.dart';
import 'package:flutter/material.dart';

class CalendarTab extends StatelessWidget {
  final ServerSocket socket;
  final AppDatabase appDatabase;
  final User user;

  const CalendarTab({Key key, this.socket, this.appDatabase, this.user})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Le tue prenotazioni:'),
        ),
        body: StatefulBuilder(builder: (context, setState) {
          return Center(
              child: Column(children: <Widget>[
            FutureBuilder<List<Prenotation>>(
                future: user.type == "ADMIN"
                    ? socket.getAllPrenotation(appDatabase)
                    : socket.getMyPrenotation(App.REMOTE_USER_ID),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Prenotation>> snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                        child: ListView.builder(
                            //importante
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Colors.white,
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      title: FutureBuilder<Class>(
                                          future: appDatabase.classDao
                                              .findClassById(
                                                  snapshot.data[index].classId),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<Class> snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                snapshot.data.name,
                                                style: TextStyle(
                                                    color: Colors.black),
                                              );
                                            } else {
                                              return Container(
                                                child: Text("Class"),
                                              );
                                            }
                                          }),
                                      subtitle: Column(
                                        children: [
                                          Text('data: ' +
                                              snapshot.data[index].getDate()),
                                          Text('orario: ' +
                                              snapshot.data[index]
                                                  .getOraInizio() +
                                              " - " +
                                              snapshot.data[index].getOraFine())
                                        ],
                                      ),
                                      trailing: TextButton(
                                        onPressed: () {
                                          snapshot.data[index]
                                              .delete(socket, appDatabase);
                                          setState(() {});
                                        },
                                        child: const Text(
                                          'ELIMINA',
                                          style: TextStyle(
                                              color: const Color(0xFFF55663)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }));
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })
          ]));
        }));
  }
}

import 'package:booking/app.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:intl/intl.dart';

import 'package:booking/data/db/app_database.dart';

import 'package:booking/data/server_socket.dart';

import 'package:booking/data/model/class.dart';
import 'package:booking/data/model/prenotation.dart';

class HomeTab extends StatelessWidget {
  final ServerSocket socket;
  final AppDatabase appDatabase;

  const HomeTab({Key key, this.socket, this.appDatabase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<List<Class>>(
                future: socket.saveAndGetClasses(appDatabase),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Class>> snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return alertDelete(context);
                                },
                              );
                            },
                            child: Card(
                              color: Colors.white,
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                children: [
                                  ListTile(
                                      title: Text(
                                        snapshot.data[index].name,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      subtitle: Text(
                                        snapshot.data[index].location,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      trailing: TextButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                _buildAboutDialog(
                                                    context,
                                                    new Prenotation(),
                                                    snapshot.data[index].id),
                                          );
                                        },
                                        child: const Text(
                                          'PRENOTA',
                                          style: TextStyle(
                                              color: Color(0xFF4CAF50)),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutDialog(
      BuildContext context, Prenotation prenotation, int classId) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: const Text('Prenota:'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Data selezionata:'),
            Text(prenotation.date == null
                ? 'not selected'
                : prenotation.date.substring(0, 10)),
            Text('Ora di inizio:'),
            Text(prenotation.oraInizio == null
                ? 'not selected'
                : prenotation.oraInizio.substring(11, 19)),
            Text('Ora di fine:'),
            Text(prenotation.oraFine == null
                ? 'not selected'
                : prenotation.oraFine.substring(11, 19)),
            SizedBox(
              height: 10,
            ),
            ButtonBar(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        maxTime: DateTime(2025, 1, 1), onChanged: (date) {
                      print('change $date');
                    }, onConfirm: (date) {
                      print('confirm $date');
                      prenotation.date = date.toString();
                      setState(() {});
                    }, currentTime: DateTime.now(), locale: LocaleType.it);
                  },
                  child: Icon(
                    Icons.calendar_today,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    DatePicker.showTime12hPicker(context,
                        showTitleActions: true, onChanged: (date) {
                      print('change $date in time zone ' +
                          date.timeZoneOffset.inHours.toString());
                    }, onConfirm: (date) {
                      print('confirm $date');
                      if (prenotation.oraInizio != null) {
                        if (date.isAfter(DateFormat('yyyy-MM-dd HH:mm:ss')
                            .parse(prenotation.oraInizio))) {
                          prenotation.oraFine = date.toString();
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alertError(context);
                            },
                          );
                        }
                      } else {
                        prenotation.oraInizio = date.toString();
                      }
                      setState(() {});
                    }, currentTime: DateTime.now());
                  },
                  child: Icon(
                    Icons.watch_later,
                  ),
                )
              ],
            ),
          ],
        ),
        actions: <Widget>[
          new TextButton(
            onPressed: () {
              prenotation.classId = classId;
              prenotation.userId = App.REMOTE_USER_ID;
              if (prenotation.isNotNull())
                prenotation.save(socket, appDatabase);
              Navigator.of(context).pop();
            },
            child: const Text(
              'Fine',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      );
    });
  }

  Widget alertError(context) {
    return AlertDialog(
      title: Text("Errore:"),
      content: Text("Selezionare un orario valido."),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget alertDelete(context) {
    return AlertDialog(
      title: Text("Modifica:"),
      content: Text("Cancella l'aula."),
      actions: [
        TextButton(
          child: Icon(Icons.delete),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            'Annulla',
            style: TextStyle(color: Colors.blue),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

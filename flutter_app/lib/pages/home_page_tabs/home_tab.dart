import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, position) {
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
                              title: const Text(
                                'Class',
                                style: TextStyle(color: Colors.black),
                              ),
                              subtitle: Text(
                                'Description',
                                style: TextStyle(color: Colors.black),
                              ),
                              trailing: TextButton(
                                //textColor: const Color(0xFF4CAF50),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    // builder: (BuildContext context) =>_buildAboutDialog(context, selectedDate,selectedFTime, selectedSTime),
                                  );
                                },
                                child: const Text('PRENOTA'),
                              )),
                        ],
                      ),
                    ),
                  );
                },
                //itemCount: counter,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutDialog(
      BuildContext context, selectedDate, selectedFTime, selectedSTime) {
    return StatefulBuilder(builder: (context, setState) {
      return new AlertDialog(
        title: const Text('Prenota:'),
        content: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Data selezionata:'),
            Text(selectedDate == ''
                ? 'not selected'
                : selectedDate.toString().substring(0, 10)),
            Text('Ora di inizio:'),
            Text(selectedFTime == ''
                ? 'not selected'
                : selectedFTime.toString().substring(11, 19)),
            Text('Ora di fine:'),
            Text(selectedSTime == ''
                ? 'not selected'
                : selectedSTime.toString().substring(11, 19)),
            SizedBox(
              height: 10,
            ),
            ButtonBar(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  //color: Colors.grey.withOpacity(0.3),
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        maxTime: DateTime(2025, 1, 1), onChanged: (date) {
                      print('change $date');
                    }, onConfirm: (date) {
                      print('confirm $date');
                      selectedDate = date;
                      setState(() {});
                    }, currentTime: DateTime.now(), locale: LocaleType.it);
                  },
                  child: Icon(
                    Icons.calendar_today,
                  ),
                ),
                TextButton(
                  //color: Colors.grey.withOpacity(0.3),
                  onPressed: () {
                    DatePicker.showTime12hPicker(context,
                        showTitleActions: true, onChanged: (date) {
                      print('change $date in time zone ' +
                          date.timeZoneOffset.inHours.toString());
                    }, onConfirm: (date) {
                      print('confirm $date');
                      if (selectedFTime != '') {
                        if (date.isAfter(selectedFTime)) {
                          selectedSTime = date;
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alertError(context);
                            },
                          );
                        }
                      } else {
                        selectedFTime = date;
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
              Navigator.of(context).pop();
            },
            //textColor: Theme.of(context).primaryColor,
            child: const Text('Fine'),
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
          //color: Colors.grey.withOpacity(0.3),
          child: Icon(Icons.delete),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          //color: Colors.grey.withOpacity(0.3),
          child: Text('Annulla'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

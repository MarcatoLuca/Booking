import 'package:flutter/material.dart';

class CalendarTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Le tue prenotazioni:'),
        ),
        body: Center(
            child: Column(children: <Widget>[
          Expanded(
              child: ListView.builder(
                  //importante
                  itemCount: 2,
                  itemBuilder: (context, position) {
                    return Card(
                      color: Colors.white,
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ListTile(
                            title: const Text(
                              'Class',
                              style: TextStyle(color: Colors.black),
                            ),
                            subtitle: Column(
                              children: [Text('data:'), Text('orario:')],
                            ),
                            trailing: TextButton(
                              onPressed: () {},
                              child: const Text(
                                'ELIMINA',
                                style:
                                    TextStyle(color: const Color(0xFFF55663)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }))
        ])));
  }
}

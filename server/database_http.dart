import 'dart:convert';
import 'dart:io';

import 'package.dart';

class DatabaseHttp {
  final http = HttpClient(); // $ json-server --host 192.168.1.55 db.json

  Future<void> postUser(Package package) async {
    await http.post("192.168.1.55", 3000, "/user")
      ..headers
          .set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8")
      ..write(jsonEncode(package.data))
      ..close();
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    List<Map<String, dynamic>> parsed;
    var request = await http.get("192.168.1.55", 3000, "/user");
    var response = await request.close();
    response.transform(utf8.decoder).listen((contents) {
      parsed = (jsonDecode(contents))
          .map((e) => e as Map<String, dynamic>)
          ?.toList();
      print(parsed.runtimeType);
    });

    return parsed;
  }
}

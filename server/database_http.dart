import 'dart:convert';
import 'dart:io';

import 'package.dart';

class DatabaseHttp {
  final http = HttpClient(); // $ json-server --host 192.168.1.55 db.json

  Future<void> postUser(Package package) async {
    await http.post("192.168.1.55", 3000, "/user")
      ..headers
          .set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8")
      ..write(jsonEncode(package.data.first))
      ..close();
  }

  Future<Package> getUsers() async {
    List packages = [];
    List<Map<String, dynamic>> datas = [];
    var request = await http.get("192.168.1.55", 3000, "/user");
    var response = await request.close();
    await response.transform(utf8.decoder).listen((contents) {
      List<dynamic> parsed = jsonDecode(contents);
      parsed.forEach((element) {
        Map<String, dynamic> data = element as Map<String, dynamic>;
        datas.add(data);
      });
      packages.add(new Package(0, datas, ""));
    }).asFuture();
    return packages.first;
  }

  Future<Package> getClasses() async {
    List packages = [];
    List<Map<String, dynamic>> datas = [];
    var request = await http.get("192.168.1.55", 3000, "/class");
    var response = await request.close();
    await response.transform(utf8.decoder).listen((contents) {
      List<dynamic> parsed = jsonDecode(contents);
      parsed.forEach((element) {
        Map<String, dynamic> data = element as Map<String, dynamic>;
        datas.add(data);
      });
      packages.add(new Package(0, datas, ""));
    }).asFuture();
    return packages.first;
  }

  Future<Package> getPrenotations() async {
    List packages = [];
    List<Map<String, dynamic>> datas = [];
    var request = await http.get("192.168.1.55", 3000, "/prenotation");
    var response = await request.close();
    await response.transform(utf8.decoder).listen((contents) {
      List<dynamic> parsed = jsonDecode(contents);
      parsed.forEach((element) {
        Map<String, dynamic> data = element as Map<String, dynamic>;
        datas.add(data);
      });
      packages.add(new Package(0, datas, ""));
    }).asFuture();
    return packages.first;
  }

  Future<Package> savePrenotation(Package package) async {
    List packages = [];
    var request = await http.post("192.168.1.55", 3000, "/prenotation")
      ..headers
          .set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8")
      ..write(jsonEncode(package.data.first));
    var response = await request.close();
    await response.transform(utf8.decoder).listen((contents) {
      Map<String, dynamic> parsed = jsonDecode(contents);
      packages.add(new Package(0, [parsed], "OK"));
    });
    return packages.first;
  }

  Future<void> deletePrenotation(Package package) async {
    int id = int.parse(package.msg);
    await http.delete("192.168.1.55", 3000, "/prenotation/$id")
      ..headers
          .set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8")
      ..close();
  }
}

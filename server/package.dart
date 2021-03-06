import 'dart:convert';

/// Code :
/// 0 - server dart <--> databaseHttp
/// 1 - user signup
/// 2 - user login
/// 3 - classes
/// 4 - prenotations GET
/// 5 - prenotation POST
/// 6 - prenotation DELETE
class Package {
  int code;
  List<Map<String, dynamic>> data;
  String msg;

  Package(this.code, this.data, this.msg);

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'data': data,
      'msg': msg,
    };
  }

  factory Package.fromMap(Map<String, dynamic> map) {
    return Package(
      map['code'],
      List<Map<String, dynamic>>.from(map['data']),
      map['msg'],
    );
  }

  factory Package.fromJson(String source) =>
      Package.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}

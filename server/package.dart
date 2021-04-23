import 'dart:convert';

/// Code :
/// 0 - server <--> database
/// 1 - user signup
/// 2 - user login
class Package {
  int code;
  Map<String, dynamic> data;
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
        map['code'], Map<String, dynamic>.from(map['data']), map['msg']);
  }

  factory Package.fromJson(String source) =>
      Package.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}

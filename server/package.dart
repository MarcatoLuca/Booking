import 'dart:convert';

/// Code :
/// 1 - user signup
class Package {
  int code;
  Map<String, dynamic> data;

  Package(this.code, this.data);

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'data': data,
    };
  }

  factory Package.fromMap(Map<String, dynamic> map) {
    return Package(
      map['code'],
      Map<String, dynamic>.from(map['data']),
    );
  }

  factory Package.fromJson(String source) =>
      Package.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}

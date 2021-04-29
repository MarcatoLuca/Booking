import 'dart:convert';

import 'package:floor/floor.dart';

@Entity(tableName: 'class')
class Class {
  @PrimaryKey(autoGenerate: true)
  final int id;
  String name;
  String location;

  Class({
    int id,
    String name,
    String location,
  })  : id = id,
        name = name,
        location = location;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
    };
  }

  factory Class.fromMap(Map<String, dynamic> map) {
    return Class(
      id: map['id'],
      name: map['name'],
      location: map['location'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Class.fromJson(String source) => Class.fromMap(json.decode(source));
}

@dao
abstract class ClassDao {
  @Query('SELECT * FROM class')
  Future<List<Class>> findAllClass();

  @Query('SELECT * FROM class WHERE id = :id')
  Future<Class> findClassById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertClass(Class classRoom);

  @delete
  Future<void> deleteClass(Class classRoom);
}

import 'package:floor/floor.dart';

@Entity(tableName: 'class')
class Class {
  @PrimaryKey(autoGenerate: false)
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

  factory Class.fromJson(Map<String, dynamic> json) => new Class(
        id: json["id"],
        name: json["name"],
        location: json["location"],
      );

  @override
  String toString() => 'Class(id: $id, name: $name, location: $location)';
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

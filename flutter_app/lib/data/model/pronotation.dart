//Ho aggiunto un ondelete cascade, così se si elima una classe o un utente, le prenotazioni associate si eliminano automaticamente

import 'dart:convert';

import 'package:booking/data/model/class.dart';
import 'package:booking/data/model/user.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'prenotation')
class Prenotation {
  @PrimaryKey(autoGenerate: true)
  final int id;
  String date;
  String oraInizio;
  String oraFine;
  @ForeignKey(
      childColumns: ["id", "date", "oraInizio", "oraFine", "userId", "classId"],
      parentColumns: ["id", "email", "password", "type"],
      entity: User,
      onDelete: ForeignKeyAction.cascade)
  final int userId;
  @ForeignKey(
      childColumns: ["id", "date", "oraInizio", "oraFine", "userId", "classId"],
      parentColumns: ["id", "name", "location"],
      entity: Class,
      onDelete: ForeignKeyAction.cascade)
  final int classId;

  Prenotation(
      {int id,
      String date,
      String oraInizio,
      String oraFine,
      int userId,
      int classId})
      : id = id,
        date = date,
        oraInizio = oraInizio,
        oraFine = oraFine,
        userId = userId,
        classId = classId;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'oraInizio': oraInizio,
      'oraFine': oraFine,
      'userId': userId,
      'classId': classId,
    };
  }

  factory Prenotation.fromMap(Map<String, dynamic> map) {
    return Prenotation(
      id: map['id'],
      date: map['date'],
      oraInizio: map['oraInizio'],
      oraFine: map['oraFine'],
      userId: map['userId'],
      classId: map['classId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Prenotation.fromJson(String source) =>
      Prenotation.fromMap(json.decode(source));
}

@dao
abstract class PrenotationTableDao {
  @Query('SELECT * FROM Prenotation')
  Future<List<Prenotation>> findAllPrenotation();

  @Query('SELECT * FROM Prenotation WHERE Prenotation.userId = :userId')
  Future<List<Prenotation>> findAllPrenotationByUserId();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> addPrenotation(Prenotation prenotation);
  @delete
  Future<void> deletePrenotation(Prenotation prenotation);
}

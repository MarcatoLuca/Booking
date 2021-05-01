//Ho aggiunto un ondelete cascade, così se si elima una classe o un utente, le prenotazioni associate si eliminano automaticamente

import 'dart:convert';

import 'package:booking/data/db/app_database.dart';
import 'package:booking/data/model/class.dart';
import 'package:booking/data/model/user.dart';
import 'package:booking/data/server_socket.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'prenotation')
class Prenotation {
  @PrimaryKey(autoGenerate: false)
  final int id;
  String date;
  String oraInizio;
  String oraFine;
  @ForeignKey(
      childColumns: ["id", "date", "oraInizio", "oraFine", "userId", "classId"],
      parentColumns: ["id", "email", "password", "type"],
      entity: User,
      onDelete: ForeignKeyAction.cascade)
  int userId;
  @ForeignKey(
      childColumns: ["id", "date", "oraInizio", "oraFine", "userId", "classId"],
      parentColumns: ["id", "name", "location"],
      entity: Class,
      onDelete: ForeignKeyAction.cascade)
  int classId;

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

  factory Prenotation.fromJson(Map<String, dynamic> json) => new Prenotation(
        id: json["id"],
        date: json["date"],
        oraInizio: json["oraInizio"],
        oraFine: json["oraFine"],
        userId: json["userId"],
        classId: json["classId"],
      );

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

  void save(ServerSocket socket, AppDatabase appDatabase) async {
    await socket.savePrenotation([this.toMap()], appDatabase);
  }

  void delete(ServerSocket socket, AppDatabase appDatabase) async {
    await socket.deletePrenotation([this.toMap()], appDatabase, this.id);
    appDatabase.prenotationDao.deletePrenotation(this);
  }

  String getDate() {
    return this.date.split(" ")[0];
  }

  String getOraInizio() {
    return this.oraInizio.split(" ")[1].split(".")[0];
  }

  String getOraFine() {
    return this.oraFine.split(" ")[1].split(".")[0];
  }

  bool isNotNull() {
    return this.classId != null &&
        this.date != null &&
        this.oraFine != null &&
        this.oraInizio != null &&
        this.userId != null;
  }

  @override
  String toString() {
    return 'Prenotation(id: $id, date: $date, oraInizio: $oraInizio, oraFine: $oraFine, userId: $userId, classId: $classId)';
  }
}

@dao
abstract class PrenotationDao {
  @Query('SELECT * FROM prenotation')
  Future<List<Prenotation>> findAllPrenotation();

  @Query(
      'SELECT * FROM prenotation WHERE oraInizio > :oraInizio1 AND oraInizio < :oraFine1 OR oraFine > :oraInizio2 AND oraFine < :oraFine2')
  Future<List<Prenotation>> checkIfClassIsFree(
      String oraInizio1, String oraFine1, String oraInizio2, String oraFine2);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPrenotation(Prenotation prenotation);

  @delete
  Future<void> deletePrenotation(Prenotation prenotation);
}

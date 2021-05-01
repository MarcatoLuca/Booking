import 'dart:async';

import 'package:booking/data/model/class.dart';
import 'package:booking/data/model/prenotation.dart';
import 'package:floor/floor.dart';

import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:booking/data/model/user.dart';

part 'app_database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [User, Class, Prenotation])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  ClassDao get classDao;
  PrenotationDao get prenotationDao;
}

// flutter packages pub run build_runner build

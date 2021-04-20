import 'dart:async';

import 'package:floor/floor.dart';

import 'package:sqflite/sqflite.dart' as sqflite;

import 'model/user.dart';

part 'app_database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [User])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
}

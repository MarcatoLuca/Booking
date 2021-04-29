// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDao _userDaoInstance;

  ClassDao _classDaoInstance;

  PrenotationDao _prenotationDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `user` (`id` INTEGER, `email` TEXT, `password` TEXT, `type` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `class` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `location` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `prenotation` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `date` TEXT, `oraInizio` TEXT, `oraFine` TEXT, `userId` INTEGER, `classId` INTEGER)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  ClassDao get classDao {
    return _classDaoInstance ??= _$ClassDao(database, changeListener);
  }

  @override
  PrenotationDao get prenotationDao {
    return _prenotationDaoInstance ??=
        _$PrenotationDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'user',
            (User item) => <String, dynamic>{
                  'id': item.id,
                  'email': item.email,
                  'password': item.password,
                  'type': item.type
                }),
        _userDeletionAdapter = DeletionAdapter(
            database,
            'user',
            ['id'],
            (User item) => <String, dynamic>{
                  'id': item.id,
                  'email': item.email,
                  'password': item.password,
                  'type': item.type
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  final DeletionAdapter<User> _userDeletionAdapter;

  @override
  Future<User> getUser(int id) async {
    return _queryAdapter.query('SELECT * FROM user WHERE user.id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => User(
            id: row['id'] as int,
            type: row['type'] as String,
            email: row['email'] as String,
            password: row['password'] as String));
  }

  @override
  Future<void> insertUser(User user) async {
    await _userInsertionAdapter.insert(user, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteUser(User user) async {
    await _userDeletionAdapter.delete(user);
  }
}

class _$ClassDao extends ClassDao {
  _$ClassDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _classInsertionAdapter = InsertionAdapter(
            database,
            'class',
            (Class item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'location': item.location
                }),
        _classDeletionAdapter = DeletionAdapter(
            database,
            'class',
            ['id'],
            (Class item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'location': item.location
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Class> _classInsertionAdapter;

  final DeletionAdapter<Class> _classDeletionAdapter;

  @override
  Future<List<Class>> findAllClass() async {
    return _queryAdapter.queryList('SELECT * FROM class',
        mapper: (Map<String, dynamic> row) => Class(
            id: row['id'] as int,
            name: row['name'] as String,
            location: row['location'] as String));
  }

  @override
  Future<Class> findClassById(int id) async {
    return _queryAdapter.query('SELECT * FROM class WHERE id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => Class(
            id: row['id'] as int,
            name: row['name'] as String,
            location: row['location'] as String));
  }

  @override
  Future<void> insertClass(Class classRoom) async {
    await _classInsertionAdapter.insert(classRoom, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteClass(Class classRoom) async {
    await _classDeletionAdapter.delete(classRoom);
  }
}

class _$PrenotationDao extends PrenotationDao {
  _$PrenotationDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _prenotationInsertionAdapter = InsertionAdapter(
            database,
            'prenotation',
            (Prenotation item) => <String, dynamic>{
                  'id': item.id,
                  'date': item.date,
                  'oraInizio': item.oraInizio,
                  'oraFine': item.oraFine,
                  'userId': item.userId,
                  'classId': item.classId
                }),
        _prenotationDeletionAdapter = DeletionAdapter(
            database,
            'prenotation',
            ['id'],
            (Prenotation item) => <String, dynamic>{
                  'id': item.id,
                  'date': item.date,
                  'oraInizio': item.oraInizio,
                  'oraFine': item.oraFine,
                  'userId': item.userId,
                  'classId': item.classId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Prenotation> _prenotationInsertionAdapter;

  final DeletionAdapter<Prenotation> _prenotationDeletionAdapter;

  @override
  Future<List<Prenotation>> findAllPrenotation() async {
    return _queryAdapter.queryList('SELECT * FROM prenotation',
        mapper: (Map<String, dynamic> row) => Prenotation(
            id: row['id'] as int,
            date: row['date'] as String,
            oraInizio: row['oraInizio'] as String,
            oraFine: row['oraFine'] as String,
            userId: row['userId'] as int,
            classId: row['classId'] as int));
  }

  @override
  Future<List<Prenotation>> checkIfClassIsFree(String oraInizio1,
      String oraFine1, String oraInizio2, String oraFine2) async {
    return _queryAdapter.queryList(
        'SELECT * FROM prenotation WHERE oraInizio > ? AND oraInizio < ? OR oraFine > ? AND oraFine < ?',
        arguments: <dynamic>[oraInizio1, oraFine1, oraInizio2, oraFine2],
        mapper: (Map<String, dynamic> row) => Prenotation(
            id: row['id'] as int,
            date: row['date'] as String,
            oraInizio: row['oraInizio'] as String,
            oraFine: row['oraFine'] as String,
            userId: row['userId'] as int,
            classId: row['classId'] as int));
  }

  @override
  Future<void> insertPrenotation(Prenotation prenotation) async {
    await _prenotationInsertionAdapter.insert(
        prenotation, OnConflictStrategy.replace);
  }

  @override
  Future<void> deletePrenotation(Prenotation prenotation) async {
    await _prenotationDeletionAdapter.delete(prenotation);
  }
}

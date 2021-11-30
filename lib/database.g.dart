// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
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

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

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
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
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
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  DoctorDao? _doctorDaoInstance;

  MedicineDao? _medicineDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
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
            'CREATE TABLE IF NOT EXISTS `Doctor` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `syncedId` INTEGER NOT NULL, `firstName` TEXT NOT NULL, `lastName` TEXT NOT NULL, `address` TEXT NOT NULL, `phone` TEXT NOT NULL, `nameOfTheClinic` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Medicine` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `syncedId` INTEGER NOT NULL, `scientificName` TEXT NOT NULL, `tradeName` TEXT NOT NULL, `producingCompany` TEXT NOT NULL, `price` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Sales` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `salesRepresentativeId` INTEGER NOT NULL, `doctorId` INTEGER NOT NULL, `remark` TEXT NOT NULL, `date` TEXT NOT NULL, `tagged` INTEGER NOT NULL, FOREIGN KEY (`doctorId`) REFERENCES `Doctor` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `SalesMedicine` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `salesId` INTEGER NOT NULL, `medicineId` INTEGER NOT NULL, `quantityType` TEXT NOT NULL, `quantity` INTEGER NOT NULL, FOREIGN KEY (`salesId`) REFERENCES `Sales` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`medicineId`) REFERENCES `Medicine` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  DoctorDao get doctorDao {
    return _doctorDaoInstance ??= _$DoctorDao(database, changeListener);
  }

  @override
  MedicineDao get medicineDao {
    return _medicineDaoInstance ??= _$MedicineDao(database, changeListener);
  }
}

class _$DoctorDao extends DoctorDao {
  _$DoctorDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _doctorInsertionAdapter = InsertionAdapter(
            database,
            'Doctor',
            (Doctor item) => <String, Object?>{
                  'id': item.id,
                  'syncedId': item.syncedId,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'address': item.address,
                  'phone': item.phone,
                  'nameOfTheClinic': item.nameOfTheClinic
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Doctor> _doctorInsertionAdapter;

  @override
  Future<List<Doctor>> findAllDoctor() async {
    return _queryAdapter.queryList('SELECT * FROM Doctor',
        mapper: (Map<String, Object?> row) => Doctor(
            row['syncedId'] as int,
            row['firstName'] as String,
            row['lastName'] as String,
            row['address'] as String,
            row['phone'] as String,
            row['nameOfTheClinic'] as String));
  }

  @override
  Stream<Doctor?> findDoctorById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Doctor WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Doctor(
            row['syncedId'] as int,
            row['firstName'] as String,
            row['lastName'] as String,
            row['address'] as String,
            row['phone'] as String,
            row['nameOfTheClinic'] as String),
        arguments: [id],
        queryableName: 'Doctor',
        isView: false);
  }

  @override
  Future<int> insertDoctor(Doctor doctor) {
    return _doctorInsertionAdapter.insertAndReturnId(
        doctor, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertDoctors(List<Doctor> doctors) {
    return _doctorInsertionAdapter.insertListAndReturnIds(
        doctors, OnConflictStrategy.abort);
  }
}

class _$MedicineDao extends MedicineDao {
  _$MedicineDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _medicineInsertionAdapter = InsertionAdapter(
            database,
            'Medicine',
            (Medicine item) => <String, Object?>{
                  'id': item.id,
                  'syncedId': item.syncedId,
                  'scientificName': item.scientificName,
                  'tradeName': item.tradeName,
                  'producingCompany': item.producingCompany,
                  'price': item.price
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Medicine> _medicineInsertionAdapter;

  @override
  Future<List<Medicine>> findAllMedicine() async {
    return _queryAdapter.queryList('SELECT * FROM Medicine',
        mapper: (Map<String, Object?> row) => Medicine(
            row['syncedId'] as int,
            row['scientificName'] as String,
            row['tradeName'] as String,
            row['producingCompany'] as String,
            row['price'] as String));
  }

  @override
  Stream<Medicine?> findMedicineById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Medicine WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Medicine(
            row['syncedId'] as int,
            row['scientificName'] as String,
            row['tradeName'] as String,
            row['producingCompany'] as String,
            row['price'] as String),
        arguments: [id],
        queryableName: 'Medicine',
        isView: false);
  }

  @override
  Future<int> insertMedicine(Medicine medicine) {
    return _medicineInsertionAdapter.insertAndReturnId(
        medicine, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertMedicines(List<Medicine> medicines) {
    return _medicineInsertionAdapter.insertListAndReturnIds(
        medicines, OnConflictStrategy.abort);
  }
}

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/add_customer.dart';

class ProductDatabaseHelper {
  static Database? _customerDb;
  static ProductDatabaseHelper? _customerDatabaseHelper;

  String table = 'productTable';
  String colId = 'id';
  String colName = "name";
  String colMobile = "mobile";
  String colEmail = "email";
  String colAdr = "address";
  String colLate = "latitude";
  String colLong = "longitude";
  String colImage = "image";

  ProductDatabaseHelper._createInstance();

  static final ProductDatabaseHelper db = ProductDatabaseHelper._createInstance();

  factory ProductDatabaseHelper() {
    if (_customerDatabaseHelper == null) {
      _customerDatabaseHelper = ProductDatabaseHelper._createInstance();
    }
    return _customerDatabaseHelper!;
  }

  Future<Database> get database async {
    if (_customerDb == null) {
      _customerDb = await initializeDatabase();
    }
    return _customerDb!;
  }

  /*Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'products.db';
    await deleteDatabaseFile();
    var myDatabase = await openDatabase(
      path,
      version: 2,
      onCreate: _createDb,
      onUpgrade: _onUpgrade,
    );
    return myDatabase;
  }
  Future<void> deleteDatabaseFile() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'products.db';
    if (await File(path).exists()) {
      await deleteDatabase(path);
      print("Old database deleted successfully.");
    }
  }*/


  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'products.db';
    var myDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return myDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute("CREATE TABLE $table"
        "($colId INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$colName TEXT, $colMobile TEXT, $colEmail TEXT, $colAdr TEXT, $colLate TEXT, $colLong TEXT, $colImage TEXT)");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute("DROP TABLE IF EXISTS $table");
      _createDb(db, newVersion);
    }
  }




  Future<List<Map<String, dynamic>>> getCustomerMapList() async {
    Database db = await this.database;
    var result = await db.query(table, orderBy: "$colId ASC");
    return result;
  }

  Future<int> insertCustomer(AddCustomer addCustomer, {cart = false}) async {
    Database db = await this.database;
    var result = await db.insert(table, addCustomer.toMap());
    print(result);
    return result;
  }

  Future<int> updateCustomer(AddCustomer addCustomer) async {
    var db = await this.database;
    var result = await db.update(table, addCustomer.toMap(),
        where: '$colId = ?', whereArgs: [addCustomer.id]);
    return result;
  }

  Future<int> deleteCustomer(int id) async {
    var db = await this.database;
    int result = await db.delete(table, where: '$colId = ?', whereArgs: [id]);
    return result;
  }

  Future<int?> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $table');
    int? result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<AddCustomer>> getCustomerList() async {
    var customerMapList = await getCustomerMapList();
    int? count = await getCount();

    List<AddCustomer> customerList = <AddCustomer>[];
    for (int i = 0; i < count!; i++) {
      customerList.add(AddCustomer.fromMap(customerMapList[i]));
    }
    return customerList;
  }

  close() async {
    var db = await this.database;
    var result = db.close();
    return result;
  }
}

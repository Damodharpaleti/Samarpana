import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider {
  static final _databaseName = "SubjeeDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'cart_table';

  static final columnProductId = 'productId';
  static final columnProductName = 'productName';
  static final columnProductCode = 'productCode';
  static final columnPrice = 'price';
  static final columnTotalPrice = 'totalPrice';
  static final columnPriceMinQuantity = 'priceMinQuantity';
  static final columnBrandname = 'brandname';
  static final columnPriceId = 'priceId';
  static final columnnumOfItems = 'numOfItems';
  static final columnCityId = 'cityId';

  static final userdata = 'User_data';

  static final columnId = 'id';
  static final columnName = 'name';
  // static final columnLastName = 'lastName';
  static final columnPhoneNumber = 'mobileNumber';
  static final columnAddress1 = 'address1';
  static final columnAddress2 = 'address2';
  static final columnCity = 'city';
  static final columnPincode = 'pinCode';
  static final columnstate = 'state';
  static final columnToken = 'token';
  //static final columnEmail = 'emailId';
  static final columnwalletamt = 'walletamt';

  // make this a singleton class
  DBProvider._privateConstructor();
  static final DBProvider instance = DBProvider._privateConstructor();

  // only have a single app-wide reference to the database
 static Database? _database;

Future<Database> get database async {
  if (_database != null) {
    return _database!;
  }

  _database = await _initDatabase();
  return _database!;
}

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnProductId INTEGER PRIMARY KEY,
            $columnProductName TEXT NOT NULL,
            $columnProductCode TEXT NOT NULL,
            $columnPrice TEXT NOT NULL,
            $columnTotalPrice REAL NOT NULL,
            $columnPriceMinQuantity INTEGER NOT NULL,
            $columnBrandname TEXT NOT NULL,
            $columnPriceId INTEGER ,
            $columnCityId INTEGER ,
            $columnnumOfItems INTEGER
          )
          ''');

    await db.execute('''
          CREATE TABLE $userdata (
            $columnId INTEGER,
            $columnName TEXT NOT NULL,
            $columnAddress1 TEXT ,
            $columnAddress2 TEXT ,
            $columnCity TEXT ,
            $columnPincode TEXT NOT NULL,
            $columnstate TEXT,
            $columnToken TEXT NOT NULL,
            $columnPhoneNumber TEXT NOT NULL,
            $columnwalletamt TEXT
          )
          ''');
  }

  Future<int> userinsert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    // print(row);
    final id = await db.insert(userdata, row);
    //print("$id");
    return id;
  }

  Future<List<Map<String, dynamic>>> queryuserRows() async {
    Database db = await instance.database;
    return await db.query(userdata);
  }

  Future<int> updateuser(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
return await db.update(userdata, row, where: '$columnId = ?', whereArgs: [id]);  }

  Future<int> updatecount() async {
    Database db = await instance.database;
    Future<List<Map<String, dynamic>>> result =
        db.rawQuery('SELECT COUNT(*) FROM cart_table');
    int count = result as int;
    //  print("cart count>>>>>>>>>>" + '$result');
    return count;
  }

  Future<int> getCount() async {
    //database connection
    Database db = await this.database;
    var x = await db.rawQuery('SELECT COUNT (*) from cart_table');
    int count = Sqflite.firstIntValue(x) ?? 0;
    return count;
  }

  Future<int> userdelete() async {
    Database db = await instance.database;
    return await db.rawDelete(" DELETE FROM $userdata ");
  }

  Future<int> cartdelete() async {
    Database db = await instance.database;
    return await db.rawDelete(" DELETE FROM $table ");
  }

  //insert into table
  productInsert(productId, productName, productCode, price, totalprice,
      priceMinQuantity, brandname, priceId, cityId, numOfItems) async {
    if (totalprice == 0.0) {
      // print(">>>>>>>dont insert");
    } else {
      final db = await database;
      var res = await db.rawInsert(
          ''' INSERT INTO $table ($columnProductId,$columnProductName,$columnProductCode,$columnPrice,$columnTotalPrice,$columnPriceMinQuantity,$columnBrandname,$columnPriceId,$columnCityId,$columnnumOfItems)VALUES(?,?,?,?,?,?,?,?,?,?) ''',
          [
            productId,
            productName,
            productCode,
            price,
            totalprice,
            priceMinQuantity,
            brandname,
            priceId,
            cityId,
            numOfItems
          ]);
      //   print(">>>>>>>inserted successfully");
      return res;
    }
  }

  userdataInsert(
    id,
    name,
    lastName,
    location,
    mobileNumber,
    token,
  ) async {
    if (name == null) {
    } else {
      final db = await database;
      var res = await db.rawInsert(
          ''' INSERT INTO $userdata ($columnId,$columnName,$columnAddress1,$columnToken,$columnPhoneNumber)VALUES(?,?,?,?,?) ''',
          [
            id,
            name,
            lastName,
            location,
            mobileNumber,
            token,
          ]);
      return res;
    }
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table')) ?? 0;
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  void updateCart(updatedPrice, pid) async {
    // row to update
    Map<String, dynamic> row = {
      columnPrice: updatedPrice,
      columnProductId: pid
      // DatabaseHelper.columnName : 'Mary',
      // DatabaseHelper.columnAge  : 32
    };
    final rowsAffected = await update(row);
    // print('updated $rowsAffected row(s)');
  }

  //
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int productId = row[columnProductId];
    return await db.update(table, row,
        where: '$columnProductId = ?', whereArgs: [productId]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db
        .delete(table, where: '$columnProductId = ?', whereArgs: [id]);
  }
}

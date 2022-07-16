import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Model/OrderModel.dart';

class OrderDatabase {
  static final OrderDatabase instance = OrderDatabase.init();

  static Database? _database;

  OrderDatabase.init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('pesan.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';

    await db.execute('''CREATE TABLE $tableOrder (
    ${OrderFields.id} $idType,
    ${OrderFields.color} $textType,
    ${OrderFields.tebal} $textType,
    ${OrderFields.items} $textType,
    ${OrderFields.price} $textType,
    ${OrderFields.lebar} $textType,
    ${OrderFields.spec} $textType,
    ${OrderFields.qty} $textType,
    ${OrderFields.disc} $textType,
    ${OrderFields.panjang} $textType
    
    
    )''');
  }

  Future<OrderModel> create(OrderModel order) async {
    final db = await instance.database;

    final id = await db.insert(tableOrder, order.toJson());
    return order.copy(id: id);
  }

  Future<OrderModel> read(int? id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableOrder,
      columns: OrderFields.values,
      where: '${OrderFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return OrderModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<OrderModel>> readAll() async {
    final db = await instance.database;

    final result = await db.query(tableOrder);

    return result.map((json) => OrderModel.fromJson(json)).toList();
  }

 update(OrderModel orderModel) async {
    final db = await instance.database;
    try {
      db.rawUpdate('''
    UPDATE ${tableOrder} 
    SET ${OrderFields.items} = ?, ${OrderFields.lebar} = ?, ${OrderFields.panjang} = ?, ${OrderFields.tebal} = ?, ${OrderFields.spec} = ?, ${OrderFields.color} = ?, ${OrderFields.qty} = ?, ${OrderFields.disc} = ?, ${OrderFields.price} = ?
    WHERE ${OrderFields.id} = ?
    ''',
          [orderModel.items, orderModel.lebar, orderModel.panjang, orderModel.tebal, orderModel.spec, orderModel.color, orderModel.qty, orderModel.disc, orderModel.price, orderModel.id]);
    } catch(e){
      print('error: ' + e.toString());
    }
  }

  delete(int? id) async {
    final db = await instance.database;
    try {
      await db.delete(
        tableOrder,
        where: '${OrderFields.id} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print(e);
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

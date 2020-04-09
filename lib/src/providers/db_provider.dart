import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qrscanner2/src/models/scan_model.dart';
export 'package:qrscanner2/src/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider{
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async{
    if(_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, 'ScansDB.db');
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db){},
      onCreate: (Database db, int version)async {
        await db.execute(
          'CREATE TABLE SCANS ('
          ' id INTEGER PRIMARY KEY,'
          ' tipo TEXT,'
          ' valor TEXT'
          ')'
        );
      }
    ); 
  }

  //CREAR REGISTROS

  nuevoScanRaw(ScanModel datos) async{
    final db = await database;
    final res = await db.rawInsert(
      "INSERT Into SCANS (id, tipo, valor) "
      "VALUES (${ datos.id }, '${ datos.tipo }', '${ datos.valor }') "
    );
    return res;
  } 

  nuevoScan(ScanModel datos) async{
    final db = await database;
    final res = await db.insert('SCANS', datos.toJson());
    return res;
  }

  //SELECT 

  Future<ScanModel> getScanId(int id) async{
    final db = await database;
    final res = await db.query('SCANS', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getTodosScans() async{
    final db = await database;
    final res = await db.query('SCANS');
    List<ScanModel> list = res.isNotEmpty ? res.map((map) => ScanModel.fromJson(map)).toList() : [];
    return list;
  }

  Future<List<ScanModel>> getScansPorTipo(String tipo) async{
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM SCANS WHERE tipo='$tipo'");
    List<ScanModel> list = res.isNotEmpty ? res.map((map) => ScanModel.fromJson(map)).toList() : [];
    return list;
  }

  //ACTUALIZAR REGISTROS

  Future<int> updateScan(ScanModel dato) async{
    final db = await database;
    final res = await db.update('SCANS', dato.toJson(), where: 'id = ?', whereArgs: [dato.id]);
    return res;
  }

  //ELIMINAR REGISTROS

  Future<int> deleteScan(int id) async{
    final db = await database;
    final res = await db.delete('SCANS', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAll() async{
    final db = await database;
    final res = await db.rawDelete('DELETE FROM SCANS');
    return res;
  }

}
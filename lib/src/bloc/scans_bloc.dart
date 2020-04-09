import 'dart:async';
import 'package:qrscanner2/src/bloc/validator.dart';
import 'package:qrscanner2/src/providers/db_provider.dart';

class ScansBloc with Validator{
  
  static final ScansBloc _singleton = ScansBloc._internal();
  
  factory ScansBloc(){
    return _singleton;
  }
  
  ScansBloc._internal(){
    //obtener los scans de la base de datos
    obtenerScan();
  }

  final _scanController = StreamController<List<ScanModel>>.broadcast();
  Stream<List<ScanModel>> get scansStream     => _scanController.stream.transform(validargeo);
  Stream<List<ScanModel>> get scansStreamHTTP => _scanController.stream.transform(validarHttp);


  dispose(){
    _scanController?.close();
  }

  obtenerScan() async{
    _scanController.sink.add(await DBProvider.db.getTodosScans());
  }

  agregarScan(ScanModel scan) async{
    await DBProvider.db.nuevoScan(scan);
    obtenerScan();
  }

  borrarScan(int id) async{
    await DBProvider.db.deleteScan(id);
    obtenerScan();
  }

  borrarTodosScan() async{
    await DBProvider.db.deleteAll();
    obtenerScan();
  }
}
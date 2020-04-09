import 'package:flutter/material.dart';
import 'package:qrscanner2/src/bloc/scans_bloc.dart';
import 'package:qrscanner2/src/models/scan_model.dart';
import 'package:qrscanner2/src/utils/utils.dart' as utils;

class MapasPage extends StatelessWidget {
  final scanBloc = ScansBloc();
  final Stream<List<ScanModel>> scanStream;
  final IconData icono;
  
  MapasPage({@required this.scanStream, @required this.icono});


  @override
  Widget build(BuildContext context) {
    scanBloc.obtenerScan();
    return StreamBuilder<List<ScanModel>>(
      stream: scanStream,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }
        final scans = snapshot.data;
        if(scans.length == 0){
          return Center(
            child: Text('No hay información'),
          );
        }
        return ListView.builder(
          itemBuilder: (context, index){
            return Dismissible(
              key: UniqueKey(),
              background: Container(color: Colors.red,),
              onDismissed: (direccion) => scanBloc.borrarScan(scans[index].id),
              child: ListTile(
                leading: Icon(icono, color: Theme.of(context).primaryColor,),
                title: Text(scans[index].valor),
                subtitle: Text('ID: ${scans[index].id}'),
                trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
                onTap: ()=>utils.abrirScan(context,scans[index]),
              ),
            );
          },
          itemCount: scans.length,
        );
      },
    );
  }
}
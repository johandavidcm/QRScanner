import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:qrscanner2/src/bloc/scans_bloc.dart';
import 'package:qrscanner2/src/models/scan_model.dart';
import 'package:qrscanner2/src/pages/mapas_page.dart';
import 'package:qrscanner2/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = ScansBloc();
  
  int paginaActual = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scansBloc.borrarTodosScan,
          )
        ],
        title: Text('QR Scanner'),
        centerTitle: true,
      ),
      body: _llamarPagina(paginaActual),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: ()=>_scanQR(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  _scanQR(BuildContext context) async{
    String futureString;
    try {
      futureString = await scanner.scan();
    } catch (e) {
      futureString = e.toString();
    }

    if(futureString != null){
      final scan = ScanModel(valor: futureString);
      scansBloc.agregarScan(scan);
      if(Platform.isIOS){
        Future.delayed(Duration(milliseconds: 750,),(){
          utils.abrirScan(context,scan);
        });
      }
      else{
        utils.abrirScan(context,scan);
      }
    }
  }

  Widget _llamarPagina(int paginaActual) {
    switch(paginaActual){
      case 0: return MapasPage(scanStream: scansBloc.scansStream, icono: Icons.map,);
      case 1: return MapasPage(scanStream: scansBloc.scansStreamHTTP, icono: Icons.cloud,);
      default: return Container();
    }  
  }

  Widget _crearBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: paginaActual,
      onTap: (index){
        setState(() {
          paginaActual = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions),
          title: Text('Direcciones')
        ),
      ],
    );
  }
}
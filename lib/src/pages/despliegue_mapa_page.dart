import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrscanner2/src/models/scan_model.dart';

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final MapController mapController = MapController();

  String tipoMapa = 'streets';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              mapController.move(scan.getLatLng(), 15);
            },
          )
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _crearFloatingActionButton(context),
    );
  }

  Widget _crearFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15,
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores(scan),
      ],
    );
  }

  TileLayerOptions _crearMapa() {
    return TileLayerOptions(
        urlTemplate: 'https://api.mapbox.com/v4/'
            '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
        additionalOptions: {
          'accessToken':
              'pk.eyJ1Ijoiam9oYW5kYXZpZGNtIiwiYSI6ImNrOHJ4bG8xYzAxNDgzZW10dXBmOHMybWkifQ.KPTObc0bC7wFvn22nk5C1g',
          'id': 'mapbox.$tipoMapa'
          //Tipos de mapas: light, dark, streets, outdoors, satellite
        });
  }

  MarkerLayerOptions _crearMarcadores(ScanModel scan) {
    return MarkerLayerOptions(markers: [
      Marker(
        width: 100.0,
        height: 100.0,
        point: scan.getLatLng(),
        builder: (context) => Container(
          child: Icon(
            Icons.location_on,
            size: 70.0,
            color: Theme.of(context).primaryColor,
          ),
        ),
      )
    ]);
  }

  Widget _crearFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        //Tipos de mapas: light, dark, streets, outdoors, satellite
        setState(() {
          if (tipoMapa == 'light') {
            tipoMapa = 'dark';
          } else if (tipoMapa == 'dark') {
            tipoMapa = 'streets';
          } else if (tipoMapa == 'streets') {
            tipoMapa = 'outdoors';
          } else if (tipoMapa == 'outdoors') {
            tipoMapa = 'satellite';
          } else if (tipoMapa == 'satellite') {
            tipoMapa = 'light';
          }
        });
      },
      child: Icon(
        Icons.repeat,
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}

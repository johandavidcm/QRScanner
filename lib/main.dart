import 'package:flutter/material.dart';
import 'package:qrscanner2/src/pages/despliegue_mapa_page.dart';
import 'package:qrscanner2/src/pages/home_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Reader',
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      routes: {
        'home' : (BuildContext context) => HomePage(),
        'mapa' : (BuildContext context) => MapaPage(),
      },
      theme: ThemeData(
        primaryColor: Colors.teal
      ),
    );
  }
}
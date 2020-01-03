import 'package:chilemergencias/utils/routes.dart' as routes;
import 'package:flutter/material.dart';
 
void main() => runApp(MyApp());

class MyApp extends StatelessWidget 
{
  //TODO: Controlar cuando se deniegue acceso a gps
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chilemergencias',
      initialRoute: "home",
      routes: routes.routeMap(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
      ),
    );
  }
}
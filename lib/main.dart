import 'package:chilemergencias/utils/routes.dart' as routes;
import 'package:flutter/material.dart';
 
void main() => runApp(MyApp());

class MyApp extends StatelessWidget 
{
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
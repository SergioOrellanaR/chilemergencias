import 'package:chilemergencias/src/providers/Provider.dart';
import 'package:chilemergencias/utils/private.dart' as privateInfo;
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hi!")),
      floatingActionButton: FloatingActionButton(onPressed: ()=>onPressedAction(),),
    );
  }


  onPressedAction() async
  {
    
    Map<String, dynamic> information = await provider.allDataToMap();
    information.forEach((k,v) => print(k));
  }
}
import 'package:flutter/material.dart';

class InformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: <Widget>[Text("Chilemergencias")],),
      body: Center(child: _body()),
    );
  }

  _body() 
  {
    Text("Este es el body");
  }
}
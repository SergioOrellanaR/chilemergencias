import 'package:flutter/material.dart';

class ErrorAlert extends StatelessWidget {

  final String alertMessage = "ha ocurrido un error";

  //ErrorAlert({this.alertMessage});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Error"),),
      body: Center( child: Text(alertMessage),),
    );
  }
}
import 'package:chilemergencias/src/widgets/ValidatorWidget.dart';
import 'package:flutter/material.dart';

class ErrorAlert extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( child: ValidatorWidget())
    );
  }
}
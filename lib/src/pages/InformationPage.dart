import 'package:flutter/material.dart';

class InformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: SafeArea(child: _body(context)),
      backgroundColor: Colors.white,
      bottomSheet: _footer(),
    );
  }

  Widget _body(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        SizedBox(height: screenSize.height * 0.05),
        _information(screenSize),
        SizedBox(height: screenSize.height * 0.05),
        _donate(screenSize),
        SizedBox(height: screenSize.height * 0.05),
        _aboutMe(screenSize),
        Expanded(
          child: SizedBox(),
        )
      ],
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: <Widget>[
          Text("Chilemergencias"),
        ],
      ),
    );
  }

  Widget _information(Size screenSize) {
    return Container(
      height: screenSize.height * 0.2,
      width: double.infinity,
      color: Colors.red,
    );
  }

  Widget _donate(Size screenSize) {
    return Container(
        height: screenSize.height * 0.2,
        width: double.infinity,
        color: Colors.green);
  }

  Widget _aboutMe(Size screenSize) {
    return Container(
      height: screenSize.height * 0.15,
      width: double.infinity,
      color: Colors.yellow,
    );
  }

  _footer() {
    return Row(
      children: <Widget>[
        Text(" Developed by: Sergio Orellana Rey"),
        Expanded(child: SizedBox()),
        Image(
          image: AssetImage("assets/chilemergenciasIcon/OrellanaLogo.png"),
          fit: BoxFit.scaleDown,
          width: 50,
          height: 50,
        ),
        SizedBox(
          width: 10,
        )
      ]
    );
  }

  GestureDetector _returnToPreviousScreen(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back,
        ));
  }
}

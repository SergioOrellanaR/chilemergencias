import 'package:flutter/material.dart';
import 'package:chilemergencias/utils/utils.dart' as utils;

class InformationCard extends StatelessWidget {

  final String name;
  final String address;
  final String commune;
  final String phone;
  final String institutionCode;

  InformationCard({@required this.name, @required this.address, this.phone, @required this.commune, @required this.institutionCode});  
  
  
  @override
  Widget build(BuildContext context) {
    return _buildCard(context);
  }

  Card _buildCard(BuildContext context) {
    return Card(
      child: SafeArea(
        child: Container(
          child: _cardData(context),
          height: (MediaQuery.of(context).orientation == Orientation.portrait)
              ? 150.0
              : 105.0,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    );
  }

  Column _cardData(BuildContext context) {
    return Column(children: <Widget>[
      ListTile(
          leading: _leadingImage(),
          title: _titleRow(),
          subtitle: _informationColumn(context),
          ),
      (MediaQuery.of(context).orientation == Orientation.portrait)
          ? _portraitActionButtons()
          : Container(),
    ]);
  }

  Widget _leadingImage() {
    String assetImage = utils.assetImageOnCardByInstitutionCode(institutionCode);

    if (assetImage != null)
    {
      return Container(
        child: Image(
          image: AssetImage(assetImage),
          fit: BoxFit.scaleDown,
        ),
      );
    }
    else
    {
      return Icon(
          Icons.photo_album,
          color: Colors.blue,
        );
    }
    
  }

  Row _portraitActionButtons() {
    return Row(
      children: <Widget>[
        FlatButton(
          child: Text("Cómo llegar"),
          onPressed: _openGoogleMapsRouting,
          textColor: Colors.blue,
        ),
        FlatButton(
          child: Text("Llamar"),
          onPressed: _realizeCall,
          textColor: Colors.blue,
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  FlatButton _callButton() {
    return FlatButton(
        child: Text("Llamar"),
        onPressed: () {},
        textColor: Colors.blue,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      );
  }

  FlatButton _howToGetButton() {
    return FlatButton(
        child: Text("Cómo llegar"),
        onPressed: () {},
        textColor: Colors.blue,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      );
  }

  Row _titleRow() {
    return Row(
      children: <Widget>[
        Text(name, style: utils.setTitleFontSize(name.length)),
        Expanded(child: SizedBox()),
        GestureDetector( onTap: () {}, child: Icon(
              Icons.close,
              size: 20.0,
            ))
      ],
    );
  }

  Widget _informationColumn(BuildContext context) {

    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return Column(
        children: <Widget>[SizedBox(height: 15.0,),Text(addressAndCommune(), style: utils.setAddressFontSize(addressAndCommune().length)),SizedBox(height: 10.0), Text((phone ?? ""))],
        crossAxisAlignment: CrossAxisAlignment.start,
      );
    }
    else
    {
      return Row(
        children: <Widget>[
          Flexible(child: Column(children: <Widget>[Text(addressAndCommune(), style: utils.setAddressFontSize(addressAndCommune().length),),SizedBox(height: 10.0,), Text(phone ?? "")])),
          Column(children: <Widget>[_howToGetButton(), _callButton()])
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      );
    }
  }

  String addressAndCommune()
  {
    return address+", "+commune;
  }

  _openGoogleMapsRouting() {}

  _realizeCall() {}

  

  
}

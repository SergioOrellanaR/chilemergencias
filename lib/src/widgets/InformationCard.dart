import 'package:chilemergencias/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chilemergencias/utils/utils.dart' as utils;
import 'package:chilemergencias/utils/globals.dart' as globals;

class InformationCard extends StatefulWidget {
  final String name;
  final String address;
  final String commune;
  final String phone;
  final String institutionCode;
  final double latitude;
  final double longitude;

  InformationCard(
      {@required this.name,
      @required this.address,
      this.phone,
      @required this.commune,
      @required this.institutionCode,
      @required this.latitude,
      @required this.longitude});

  @override
  _InformationCardState createState() => _InformationCardState();
}

class _InformationCardState extends State<InformationCard> {
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(opacity: globals.isInformationCardVisible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 800), child: Visibility(child: _buildCard(context), visible: globals.isInformationCardVisible));
  }

  Card _buildCard(BuildContext context) {
    bool orientationIsPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Card(
      child: SafeArea(
        child: Container(
          child: _cardData(context, orientationIsPortrait),
          height: (orientationIsPortrait) ? 165.0 : 105.0,
          padding: EdgeInsets.only(top: 20.0),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Colors.white,
    );
  }

  Column _cardData(BuildContext context, bool orientationIsPortrait) {
    return Column(children: <Widget>[
      // SizedBox(height: 25.0),
      ListTile(
        leading: _leadingImage(),
        title: _titleRow(),
        subtitle: _informationColumn(context, orientationIsPortrait),
      ),
      (orientationIsPortrait) ? _portraitActionButtons() : Container(),
    ]);
  }

  Widget _leadingImage() {
    String assetImage =
        utils.assetImageOnCardByInstitutionCode(widget.institutionCode);

    if (assetImage != null) {
      return Container(
        child: Image(
          image: AssetImage(assetImage),
          fit: BoxFit.scaleDown,
        ),
      );
    } else {
      return Icon(
        Icons.photo_album,
        color: Colors.blue,
      );
    }
  }

  Row _portraitActionButtons() {
    return Row(
      children: <Widget>[
        _callEmergency(padded: true),
        _howToGetButton(padded: true),
        _callButton(padded: true)
      ],
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    );
  }

  Widget _callButton({bool padded = false}) {
    if (widget.phone != null) {
      return FlatButton(
        child: Row(
          children: <Widget>[
            Icon(Icons.call),
            Text("Llamar"),
          ],
        ),
        onPressed: _realizePhoneCall,
        textColor: Colors.blue,
        materialTapTargetSize: padded
            ? MaterialTapTargetSize.padded
            : MaterialTapTargetSize.shrinkWrap,
      );
    } else {
      return Container();
    }
  }

  FlatButton _howToGetButton({bool padded = false}) {
    return FlatButton(
      child: Row(
        children: <Widget>[
          Icon(Icons.navigation),
          Text("Cómo llegar"),
        ],
      ),
      onPressed: _openGoogleMapsRouting,
      textColor: Colors.blue,
      materialTapTargetSize: padded
          ? MaterialTapTargetSize.padded
          : MaterialTapTargetSize.shrinkWrap,
    );
  }

  FlatButton _callEmergency({bool padded = false}) {
    String shortPhoneNumber = utils.emergencyShortPhoneCall(widget.institutionCode);
    return FlatButton(
      child: Row(
        children: <Widget>[
          Icon(Icons.phone),
          Text(shortPhoneNumber),
        ],
      ),
      onPressed: () => _callShortPhoneEmergency(shortPhoneNumber),
      textColor: Colors.blue,
      materialTapTargetSize: padded
          ? MaterialTapTargetSize.padded
          : MaterialTapTargetSize.shrinkWrap,
    );
  }

  Row _titleRow() {
    return Row(
      children: <Widget>[
        Expanded(child: Text(widget.name, style: utils.setTitleFontSize(widget.name.length))),
        GestureDetector(     
            onTap: () {
              setState(() {
                globals.isInformationCardVisible = false;
              });
            },
            child: Icon(
              Icons.close,
              size: 20.0,
            ))
      ],
    );
  }

  Widget _informationColumn(BuildContext context, bool orientationIsPortrait) {
    if (orientationIsPortrait) {
      return Column(
        children: <Widget>[
          SizedBox(
            height: 5.0,
          ),
          Text(addressAndCommune(),
              style: utils.setAddressFontSize(addressAndCommune().length)),
          SizedBox(height: 10.0),
          Text((widget.phone ?? ""))
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      );
    } else {
      return Row(
        children: <Widget>[
          Flexible(
              child: Column(children: <Widget>[
            Text(
              addressAndCommune(),
              style: utils.setAddressFontSize(addressAndCommune().length),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(widget.phone ?? "")
          ])),
          Column(children: <Widget>[_howToGetButton(), _callButton()])
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      );
    }
  }

  String addressAndCommune() {
    return widget.address + ", " + widget.commune;
  }

  _openGoogleMapsRouting() {
    MapUtils.openMap(widget.latitude, widget.longitude);
  }

  _realizePhoneCall() {
    launch("tel://" + widget.phone);
  }

  _callShortPhoneEmergency(String number) {
    launch("tel://" + number);
  }
}

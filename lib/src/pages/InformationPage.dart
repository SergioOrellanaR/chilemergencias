import 'dart:async';
import 'dart:io';
import 'package:chilemergencias/src/controllers/AlertHandler.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class InformationPage extends StatefulWidget {
  final String coffeeId = "serorellanar_chilemergencias_coffee";
  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  void initState() {
    final Stream purchaseUpdates =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdates.listen((purchases) {
      _handlePurchaseUpdates(purchases);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body:
            Stack(children: <Widget>[_background(), _bodyInformation(context)]),
        backgroundColor: Colors.white,
        bottomSheet: _footer());
  }

  Container _background() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
        Color.fromRGBO(55, 70, 96, 1.0),
        Color.fromRGBO(164, 171, 189, 1.0),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
    );
  }

  SafeArea _bodyInformation(BuildContext context) {
    return SafeArea(child: ListView(children: _bodyBuilder(context)));
  }

  List<Widget> _bodyBuilder(BuildContext context) {
    List<Widget> bodyList = [
      SizedBox(height: 30.0),
      _information(),
      SizedBox(height: 30.0),
      _donate(context),
      SizedBox(height: 30.0),
      _contactMe(),
      SizedBox(height: 100.0),
    ];
    return bodyList;
  }

  AppBar _appBar() {
    return AppBar(
      title: Row(
        children: <Widget>[
          Text("Chilemergencias"),
          Expanded(child: SizedBox()),
          Image(
              image: AssetImage("assets/chilemergenciasIcon/Logo.png"),
              width: 30,
              height: 30)
        ],
      ),
      backgroundColor: Color.fromRGBO(55, 70, 96, 1.0),
      //   flexibleSpace: Container(
      //       decoration: BoxDecoration(
      //         gradient: LinearGradient(
      //           begin: Alignment.centerLeft,
      //             end: Alignment.bottomRight,
      //             colors: <Color>[
      //           Colors.blue,
      //           Colors.white54,
      //           Colors.red,
      //         ])
      //      ),
      //  ),
    );
  }

  Widget _information() {
    return _card(
        title: "¿Como funciona 'Chilemergencias'?",
        description:
            "La aplicación muestra en el mapa 9 servicios de urgencia mas cercanos a su posición actual (3 servicios de urgencia médica, 3 estaciones de bomberos y 3 establecimientos policiales), presionando en el ícono a la institución correspondiente puede buscar el servicio de urgencia mas cercano, además de ello, puede consultar los datos de cada una presionando en el ícono que se muestra en el mapa",
        gradient: LinearGradient(colors: <Color>[
          Color.fromRGBO(109, 211, 233, 1.0),
          Color.fromRGBO(243, 231, 246, 1.0),
        ], begin: Alignment.topLeft, end: Alignment.bottomRight));
  }

  Widget _donate(BuildContext context) {
    return _card(
        context: context,
        title: "Si la aplicación te ha servido, puedes invitarme a un café :)",
        description:
            "Para que usted pueda responder a la urgencia de la forma más rápida posible es que esta aplicación no contiene anuncios ni cobros, sin embargo, si la aplicación le ha servido, puede invitarme a un café (por 1500 pesos) presionando en el siguiente ícono: ",
        haveIcon: true,
        gradient: LinearGradient(colors: <Color>[
          Color.fromRGBO(150, 230, 230, 1.0),
          Color.fromRGBO(242, 236, 238, 1.0),
        ], begin: Alignment.topLeft, end: Alignment.bottomRight));
  }

  Widget _contactMe() {
    return _card(
        title: "¡Tambien puedes contactarme directamente!",
        description:
            "Si has encontrado un error en la aplicación, compartir como te sirvió la app, hablar de negocios o simplemente deseas dar retroalimentación puedes contactarme al siguiente email: ",
        haveEmail: true,
        gradient: LinearGradient(colors: <Color>[
          Color.fromRGBO(191, 205, 237, 1.0),
          Color.fromRGBO(241, 241, 230, 1.0),
        ], begin: Alignment.topLeft, end: Alignment.bottomRight));
  }

  Widget _card(
      {BuildContext context,
      String title,
      String description,
      bool haveIcon = false,
      bool haveEmail = false,
      Gradient gradient}) {
    return GradientCard(
        child: Column(children: <Widget>[
          _cardListTile(title, description, context, haveIcon, haveEmail),
          Divider(),
        ]),
        clipBehavior: Clip.antiAlias,
        gradient: gradient,
        elevation: 6.0,
        semanticContainer: true,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)));
  }

  ListTile _cardListTile(String title, String description, BuildContext context,
      bool haveIcon, bool haveEmail) {
    return ListTile(
      title: Text(title, textAlign: TextAlign.center),
      subtitle: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Text(description, textAlign: TextAlign.justify),
          SizedBox(height: 5),
          _donateIcon(context, haveIcon),
          _email(haveEmail)
        ],
      ),
      isThreeLine: true,
    );
  }

  Widget _donateIcon(BuildContext context, bool haveIcon) {
    Container iconBuild = Container(
      child: GestureDetector(
          onTap: () async {
            try {
              bool canAccessToStore = await _storeIsAvailable();
              if (canAccessToStore) {
                await _payCoffee();
              } else {
                _displayAlertCard(context, alertController["unreachableStore"]);
              }
            } catch (e) {
              _displayAlertCard(context, alertController["unknownError"]);
            }
          },
          child: Icon(
            Icons.local_cafe,
            color: Colors.white,
            size: 40.0,
          )),
      height: 60.0,
      width: 60.0,
      decoration: BoxDecoration(
          color: Color.fromRGBO(89, 191, 213, 1.0), shape: BoxShape.circle),
    );

    return haveIcon ? iconBuild : Container();
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        if (purchaseDetails.status == PurchaseStatus.purchased) {
          _displayAlertCard(context, alertController["succesfulDonation"]);
        } else if (purchaseDetails.status == PurchaseStatus.error) {
          _displayAlertCard(context, alertController["unsuccesfulDonation"]);
          return;
        }
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await InAppPurchaseConnection.instance
            .completePurchase(purchaseDetails);
      }
    });

  }

  Future<bool> _storeIsAvailable() async {
    return await InAppPurchaseConnection.instance.isAvailable();
  }

  _email(bool haveEmail) {
    Text textEmail = Text(
      "serorellanar@gmail.com",
      textAlign: TextAlign.center,
      style:
          TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),
    );
    return haveEmail ? textEmail : Container();
  }

  _footer() {
    return Container(
      child: Row(children: <Widget>[
        Text(" Developed by: Sergio Orellana Rey - V1.0.0", style: TextStyle(fontSize: 12.5),),
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
      ]),
      color: Color.fromRGBO(164, 171, 189, 1.0),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _displayAlertCard(BuildContext context, AlertHandler error) {
    showAlert(context, error);
  }

  showAlert(BuildContext context, AlertHandler error) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return _alertDialog(error, context);
        });
  }

  AlertDialog _alertDialog(AlertHandler error, BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text(error.title),
      content: _alertDialogContent(error),
      actions: <Widget>[_okButtonOnDialog(context, error)],
    );
  }

  Column _alertDialogContent(AlertHandler error) {
    return Column(children: <Widget>[
      Text(error.description, textAlign: TextAlign.justify),
      Expanded(
        child: Container(
          child: Icon(
            error.iconData,
            color: error.iconColor,
            size: 100.0,
          ),
          height: 150.0,
          width: 150.0,
          decoration: BoxDecoration(
              color: error.iconBackgroundColor, shape: BoxShape.circle),
        ),
      ),
    ], mainAxisSize: MainAxisSize.min);
  }

  FlatButton _okButtonOnDialog(BuildContext context, AlertHandler error) {
    return FlatButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.of(context).pop();
          error.action();
        });
  }

  Future<bool> _payCoffee() async {
    if (Platform.isAndroid) {
      Set<String> _productsId = <String>[widget.coffeeId].toSet();
      final ProductDetailsResponse response = await InAppPurchaseConnection
          .instance
          .queryProductDetails(_productsId);
      PurchaseParam purchaseParam =
          PurchaseParam(productDetails: response.productDetails[0]);
      InAppPurchaseConnection.instance
          .buyConsumable(purchaseParam: purchaseParam, autoConsume: true);
    } else {
      //TODO: Programar compra mediante AppStore
    }
    return true;
  }
}

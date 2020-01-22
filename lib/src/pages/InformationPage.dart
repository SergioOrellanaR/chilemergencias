import 'package:flutter/material.dart';

class InformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SafeArea(
          child: ListView(
        children: _body(),
      )),
      backgroundColor: Colors.white,
      bottomSheet: _footer(),
    );
  }

  List<Widget> _body() {
    List<Widget> bodyList = [
      SizedBox(height: 30.0),
      _information(),
      SizedBox(height: 30.0),
      _donate(),
      SizedBox(height: 30.0),
      _contactMe(),
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
    );
  }

  Widget _information() {
    return _card(
        title: "¿Como funciona 'Chilemergencias'?",
        description:
            "La aplicación muestra en el mapa 9 servicios de urgencia mas cercanos a su posición actual (3 servicios de urgencia médica, 3 estaciones de bomberos y 3 establecimientos policiales), presionando en el ícono a la institución correspondiente puede buscar el servicio de urgencia mas cercano, además de ello, puede consultar los datos de cada una presionando en el ícono que se muestra en el mapa");
  }

  Widget _donate() {
    return _card(
        title: "Si la aplicación te ha servido, puedes invitarme a un café!",
        description:
            "Para que usted pueda responder a la urgencia de la forma más rápida posible es que esta aplicación no contiene anuncios ni cobros, sin embargo, si la aplicación le ha servido, puede invitarme a un café (por 1500 pesos) presionando en el siguiente ícono: ",
        haveIcon: true);
  }

  Widget _contactMe() {
    return _card(
      title: "Tambien puedes contactarme directamente!",
      description: "Si has encontrado un error en la aplicación, compartir como te sirvió la app, hablar de negocios o simplemente deseas dar retroalimentación puedes contactarme al siguiente email: ",
      haveEmail: true
    );
  }

  Widget _card({String title, String description, bool haveIcon = false, bool haveEmail = false}) {
    return Card(
      child: Column(children: <Widget>[
        ListTile(
          title: Text(title, textAlign: TextAlign.center),
          subtitle: Column(
            children: <Widget>[
              SizedBox(height: 10),
              Text(description, textAlign: TextAlign.justify),
              SizedBox(height: 5),
              _donateIcon(haveIcon),
              _email(haveEmail)
            ],
          ),
          isThreeLine: true,
        ),
        Divider(),
      ]),
      borderOnForeground: true,
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      elevation: 6.0,
      semanticContainer: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    );
  }

  Widget _donateIcon(bool haveIcon) {
    Container iconBuild = Container(
      child: GestureDetector(
          onTap: () {
            //TODO: Agregar botón de donación.
          },
          child: Icon(
            Icons.local_cafe,
            color: Colors.white,
            size: 40.0,
          )),
      height: 60.0,
      width: 60.0,
      decoration: BoxDecoration(color: Colors.teal, shape: BoxShape.circle),
    );

    return haveIcon ? iconBuild : Container();
  }

  _footer() {
    return Row(children: <Widget>[
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
    ]);
  }

  _email(bool haveEmail) 
  {
    Text textEmail = Text("serorellanar@gmail.com", textAlign: TextAlign.center, style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),);
    return haveEmail ? textEmail : Container();
  }
}

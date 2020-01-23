import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class InformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Stack(children: <Widget>[
        _background(),
        _bodyInformation()]),
      backgroundColor: Colors.white,
      bottomSheet: _footer()
    );
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

  SafeArea _bodyInformation() {
    return SafeArea(
          child: ListView(
        children: _bodyBuilder())

    );
  }

  List<Widget> _bodyBuilder() {
    List<Widget> bodyList = [
      SizedBox(height: 30.0),
      _information(),
      SizedBox(height: 30.0),
      _donate(),
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
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight));
  }

  Widget _donate() {
    return _card(
        title: "Si la aplicación te ha servido, puedes invitarme a un café :)",
        description:
            "Para que usted pueda responder a la urgencia de la forma más rápida posible es que esta aplicación no contiene anuncios ni cobros, sin embargo, si la aplicación le ha servido, puede invitarme a un café (por 1500 pesos) presionando en el siguiente ícono: ",
        haveIcon: true,
        gradient: LinearGradient(colors: <Color>[
          Color.fromRGBO(150, 230, 230, 1.0),
          Color.fromRGBO(242, 236, 238, 1.0),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight));
  }

  Widget _contactMe() {
    return _card(
      title: "¡Tambien puedes contactarme directamente!",
      description: "Si has encontrado un error en la aplicación, compartir como te sirvió la app, hablar de negocios o simplemente deseas dar retroalimentación puedes contactarme al siguiente email: ",
      haveEmail: true,
      gradient: LinearGradient(colors: <Color>[
          Color.fromRGBO(191, 205, 237, 1.0),
          Color.fromRGBO(241, 241, 230, 1.0),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight)
    );
  }

  Widget _card({String title, String description, bool haveIcon = false, bool haveEmail = false, Gradient gradient}) {
    return GradientCard(
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
      clipBehavior: Clip.antiAlias,
      gradient: gradient,
      elevation: 6.0,
      semanticContainer: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
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
      decoration: BoxDecoration(color: Color.fromRGBO(89, 191, 213, 1.0), shape: BoxShape.circle),
    );

    return haveIcon ? iconBuild : Container();
  }

  _footer() {
    return Container(
      child: Row(children: <Widget>[
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
      ]),
      color: Color.fromRGBO(164, 171, 189, 1.0),
    );
  }

  _email(bool haveEmail) 
  {
    Text textEmail = Text("serorellanar@gmail.com", textAlign: TextAlign.center, style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),);
    return haveEmail ? textEmail : Container();
  }
}
import 'dart:async';
import 'dart:io';
import 'package:chilemergencias/src/controllers/ErrorHandler.dart';
import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:chilemergencias/utils/utils.dart' as utils;


class ValidatorWidget extends StatefulWidget {
  @override
  _ValidatorWidgetState createState() => _ValidatorWidgetState();
}

class _ValidatorWidgetState extends State<ValidatorWidget> {
  bool _errorExist = false;
  bool _thereIsAOpenDialog = false;
  String _lastErrorId;
  Map<String, bool> _mapValues = new Map<String, bool>();
  StreamController<int> streamController = StreamController<int>.broadcast();
  Stream<int> timer =
      Stream.periodic(Duration(seconds: 5), (int count) => count);

  @override
  void initState() {
    super.initState();
    streamController.addStream(Stream.periodic(Duration(seconds: 5), (int count) => count));
    //streamTest = Stream.periodic(Duration(seconds: 1), (int value) => _mapValues);
  }

  @override
  Widget build(BuildContext context) {
    return _errorExist ? Container() : listenStream();
    //return (_errorExist ? _showAlert(context) : Container());
  }

  _showAlert(BuildContext context, ErrorHandler error) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text(error.title),
            content: Column(children: <Widget>[
              Text(error.description),
              SizedBox(height: 20.0,),
              Container(
                child: Icon(error.iconData,
                color: error.iconColor,
                size: 100.0,
                ),
                height: 150.0,
                width: 150.0,
                decoration: BoxDecoration(
                  color: error.iconBackgroundColor,
                  shape: BoxShape.circle
                ),
              ),
            ], mainAxisSize: MainAxisSize.min),
            actions: <Widget>[
              FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    _thereIsAOpenDialog = false;
                    _errorExist = false;
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  listenStream() {
    return StreamBuilder(
      stream: streamController.stream,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasData) {
          _errorsInformation();
          _mapValues.forEach((key, value) {
            if (value == false && _thereIsAOpenDialog == false && _lastErrorId != key) {
              ErrorHandler error = utils.getErrorInformationByErrorCode(key);
              _thereIsAOpenDialog = true;
              _errorExist = true;
              _lastErrorId = key;
              Future.delayed(Duration.zero, () => _showAlert(context, error));
            }
            else if(value == true && _lastErrorId == key)
            {
              _lastErrorId = null;
            }
          }
          );
          print(_mapValues["haveConectivity"].toString() +
              " " +
              snapshot.data.toString());
          return Container();
        } else {
          print("Snapshot sin data");
          return Container();
        }
      },
    );
  }

  Future<Map<String, bool>> _errorsInformation() async {
    //TODO: Checkear que GPS Tiene permisos, y si no, solicitarlos o pedir activar
    //TODO: Checkear que GPS funcione.
    //TODO: Que al activar o mejorar la condición de alguno de estos problemas la aplicación vuelva a cargar (Usar streams).
    bool _isPermissionGranted = await _isPermissionStatusGranted();
    bool _isStatusEnabled = await _isServiceStatusEnabled();
    bool _haveConectivity = await _phoneHaveConectivity();

    Map<String, bool> errorsInformation = new Map<String, bool>();

    errorsInformation.putIfAbsent(
        "permissionGranted", () => _isPermissionGranted);
    errorsInformation.putIfAbsent("statusEnabled", () => _isStatusEnabled);
    errorsInformation.putIfAbsent("haveConectivity", () => _haveConectivity);

    _mapValues = errorsInformation;

    return errorsInformation;
  }

  Future<bool> _isPermissionStatusGranted() async {
    return await LocationPermissions().checkPermissionStatus() ==
        PermissionStatus.granted;
  }

  Future<bool> _isServiceStatusEnabled() async {
    return await LocationPermissions().checkServiceStatus() ==
        ServiceStatus.enabled;
  }

  Future<bool> _phoneHaveConectivity() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}

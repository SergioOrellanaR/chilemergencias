import 'dart:async';
import 'package:chilemergencias/src/controllers/ErrorHandler.dart';
import 'package:flutter/material.dart';
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
  // Stream<int> timer =
  //     Stream.periodic(Duration(seconds: 1), (int count) => count);

  @override
  void initState() {
    super.initState();
    streamController
        .addStream(Stream.periodic(Duration(seconds: 1), (int count) => count));
  }

  @override
  Widget build(BuildContext context) {
    return _errorExist ? Container() : listenStream(context);
    //return (_errorExist ? _showAlert(context) : Container());
  }

  showAlert(BuildContext context, ErrorHandler error) {
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
              SizedBox(
                height: 20.0,
              ),
              Container(
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
            ], mainAxisSize: MainAxisSize.min),
            actions: <Widget>[
              FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    _thereIsAOpenDialog = false;
                    _errorExist = false;
                    Navigator.of(context).pop();
                    error.action(context);
                  })
            ],
          );
        });
  }

  listenStream(BuildContext appContext) {
    return StreamBuilder(
      stream: streamController.stream,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasData) {
          _errorsInformation();
          _mapValues.forEach((key, value) {
            if (value == false && _thereIsAOpenDialog == false) {
              ErrorHandler error = utils.getErrorInformationByErrorCode(key);
              if (error.isPersistent || _lastErrorId != key) {
                ErrorHandler error = utils.getErrorInformationByErrorCode(key);
                _thereIsAOpenDialog = true;
                _errorExist = true;
                _lastErrorId = key;
                Future.delayed(Duration.zero, () => showAlert(context, error));
              }
            } else if (value == true && _lastErrorId == key) {
              _lastErrorId = null;
            }
          });

          // if(_mapValues != null && theresNoErrors() && _thereWasAnError)
          // {
          //   RestartWidget.restartApp(context);
            
          // }

          return Container();
        } else {
          print("Snapshot sin data");
          return Container();
        }
      },
    );
  }

  bool theresNoErrors()
  {
    bool thereAreNoErrors = true;

    _mapValues.forEach((key,value)
    {
      if(value == false)
      {
        thereAreNoErrors = false;
      }
    });

    return thereAreNoErrors;
  }

  Future<Map<String, bool>> _errorsInformation() async {
    bool _isPermissionGranted = await utils.isPermissionStatusGranted();
    bool _isStatusEnabled = await utils.isServiceStatusEnabled();
    bool _haveConectivity = await utils.phoneHaveConectivity();

    Map<String, bool> errorsInformation = new Map<String, bool>();

    errorsInformation.putIfAbsent(
        "permissionGranted", () => _isPermissionGranted);
    errorsInformation.putIfAbsent("statusEnabled", () => _isStatusEnabled);
    errorsInformation.putIfAbsent("haveConectivity", () => _haveConectivity);

    _mapValues = errorsInformation;

    return errorsInformation;
  }
}

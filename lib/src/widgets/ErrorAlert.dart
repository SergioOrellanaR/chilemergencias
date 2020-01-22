import 'dart:async';
import 'package:chilemergencias/src/pages/HomePage.dart';
import 'package:chilemergencias/src/widgets/ValidatorWidget.dart';
import 'package:flutter/material.dart';
import 'package:chilemergencias/utils/utils.dart' as utils;

class ErrorAlert extends StatefulWidget {
  @override
  _ErrorAlertState createState() => _ErrorAlertState();
}

class _ErrorAlertState extends State<ErrorAlert> {
  bool _theresNoError;
  Widget _widget = Container();
  Map<String, bool> _mapValues = new Map<String, bool>();
  StreamController<int> streamController = StreamController<int>.broadcast();

  @override
  void initState() {
    super.initState();
    _theresNoError = false;
    streamController
        .addStream(Stream.periodic(Duration(seconds: 1), (int count) => count));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: listenStream()));
  }

  disposeStream() {
    streamController?.close();
  }

  Widget listenStream() {
    return StreamBuilder(
      stream: streamController.stream,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasData) {
          _errorsInformation();
          _theresNoError = theresNoErrors();
          
          if (_theresNoError) {
            Timer.run(() {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (Route<dynamic> route) => false);
            });
          } else {
            _widget = ValidatorWidget(isStartUpValidation: true,);
          }

          return _widget;
        } else {
          return Container();
        }
      },
    );
  }

  bool theresNoErrors() {
    bool thereAreNoErrors = true;

    if (_mapValues.length > 0) {
      _mapValues.forEach((key, value) {
        if (value == false) {
          thereAreNoErrors = false;
        }
      });
    } else {
      thereAreNoErrors = false;
    }

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

  @override
  void dispose() {
    //disposeStream();
    super.dispose();
  }
}

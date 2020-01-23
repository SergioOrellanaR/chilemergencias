import 'dart:async';
import 'package:chilemergencias/src/controllers/ErrorHandler.dart';
import 'package:flutter/material.dart';
import 'package:chilemergencias/utils/utils.dart' as utils;

class ValidatorWidget extends StatefulWidget {
  final bool isStartUpValidation;

  ValidatorWidget({this.isStartUpValidation = false});

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

  disposeStream() {
    streamController?.close();
  }

  showAlert(BuildContext context, ErrorHandler error) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return _alertDialog(error, context);
        });
  }

  AlertDialog _alertDialog(ErrorHandler error, BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text(error.title),
      content: _alertDialogContent(error),
      actions: <Widget>[_okButtonOnDialog(context, error)],
    );
  }

  Column _alertDialogContent(ErrorHandler error) {
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

  FlatButton _okButtonOnDialog(BuildContext context, ErrorHandler error) {
    return FlatButton(
        child: Text("OK"),
        onPressed: () {
          _thereIsAOpenDialog = false;
          _errorExist = false;
          Navigator.of(context).pop();
          error.action();
        });
  }

  listenStream(BuildContext appContext) {
    return StreamBuilder(
      stream: streamController.stream,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasData) {
          _errorsInformation();
          _validateActualErrors(context);
          return Container();
        } else {
          // print("Snapshot sin data");
          return Container();
        }
      },
    );
  }

  void _validateActualErrors(BuildContext context) {
    return _mapValues.forEach((key, value) {
      if (value == false && _thereIsAOpenDialog == false) {
        ErrorHandler error = utils.getErrorInformationByErrorCode(key);
        if (_showDisplayAlert(error, key)) {
          _thereIsAOpenDialog = true;
          _errorExist = true;
          _lastErrorId = key;
          Future.delayed(Duration.zero, () => showAlert(context, error));
        }
      } else if (value == true && _lastErrorId == key) {
        _lastErrorId = null;
      }
    });
  }

  bool _showDisplayAlert(ErrorHandler error, String mapKey) {
    return error.isPersistent ||
        _lastErrorId != mapKey ||
        _isPersistentOnStartUp(error);
  }

  bool _isPersistentOnStartUp(ErrorHandler error) {
    bool value = false;
    if (widget.isStartUpValidation && error.isPersistentOnStartUp) {
      value = true;
    }
    return value;
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

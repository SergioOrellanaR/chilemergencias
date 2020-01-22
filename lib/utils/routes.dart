import 'package:chilemergencias/src/pages/HomePage.dart';
import 'package:chilemergencias/src/pages/InformationPage.dart';
import 'package:chilemergencias/src/widgets/ErrorAlert.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> routeMap() {
   return <String, WidgetBuilder>{
   "home": (BuildContext context) => HomePage(),
   "error": (BuildContext context) => ErrorAlert(),
   "information": (BuildContext context) => InformationPage(),
   };
}
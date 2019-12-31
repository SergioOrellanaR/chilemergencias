import 'package:chilemergencias/src/pages/HomePage.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> routeMap() {
   return <String, WidgetBuilder>{
   "home": (BuildContext context) => HomePage(),
   };
}
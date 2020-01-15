import 'dart:convert';
import 'package:chilemergencias/src/models/BomberosModel.dart';
import 'package:chilemergencias/src/models/CarabinerosModel.dart';
import 'package:chilemergencias/src/models/UrgenciasModel.dart';
import 'package:flutter/services.dart' show rootBundle;


class _Provider
{
  List<UrgenciasModel>    urgencias;
  List<BomberosModel>     bomberos;
  List<CarabinerosModel>  carabineros;

  _Provider()
  {
    //loadData();
  }

  Future<Map<String, dynamic>> allDataToMap() async
  {
    await initData();

    Map<String,dynamic> allData = new Map();

    for(int i=0; i < urgencias.length ; i++)
    {
      allData.putIfAbsent(i.toString()+"_Urgen", ()=> urgencias[i]);
    }

    for(int i=0; i < bomberos.length ; i++)
    {
      allData.putIfAbsent(i.toString()+"_Bombe", ()=> bomberos[i]);
    }

    for(int i=0; i < carabineros.length ; i++)
    {
      allData.putIfAbsent(i.toString()+"_Carab", ()=> carabineros[i]);
    }

    return allData;
  }

  Future initData() async {
    urgencias   = await loadUrgencias();
    bomberos    = await loadBomberos();
    carabineros = await loadCarabineros();
  }

  Future<List<UrgenciasModel>> loadUrgencias() async
  {

    final data = await rootBundle.loadString('data/urgencias.json');
    final dataMap = json.decode(data);

    List<UrgenciasModel> urgenciasList = new List();

    for (var item in dataMap) {

      UrgenciasModel urgencia = UrgenciasModel.fromJson(item);
      urgenciasList.add(urgencia);
      
    }

    return urgenciasList;
  }

  Future<List<BomberosModel>> loadBomberos() async
  {

    final data = await rootBundle.loadString('data/bomberos.json');
    final dataMap = json.decode(data);

    List<BomberosModel> bomberosList = new List();

    for (var item in dataMap) {

      BomberosModel bombero = BomberosModel.fromJson(item);
      bomberosList.add(bombero);
      
    }

    return bomberosList;
  }

  Future<List<CarabinerosModel>> loadCarabineros() async
  {

    final data = await rootBundle.loadString('data/carabineros.json');
    final dataMap = json.decode(data);

    List<CarabinerosModel> carabinerosList = new List();

    for (var item in dataMap) {

      CarabinerosModel carabinero = CarabinerosModel.fromJson(item);

      if(!carabinero.isRural)
        carabinerosList.add(carabinero);      
    }

    return carabinerosList;
  }

}

final provider = new _Provider();
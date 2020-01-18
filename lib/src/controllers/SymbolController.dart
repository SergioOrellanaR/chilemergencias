import 'package:mapbox_gl/mapbox_gl.dart' as mapBox;

class SymbolController {
  List<mapBox.Symbol> urgenciasSymbols;
  List<mapBox.Symbol> bomberosSymbols;
  List<mapBox.Symbol> carabinerosSymbols;
  

  SymbolController()
  {
    urgenciasSymbols = new List<mapBox.Symbol>();
    bomberosSymbols = new List<mapBox.Symbol>();
    carabinerosSymbols = new List<mapBox.Symbol>();
  }
  
}
import 'package:mapbox_gl/mapbox_gl.dart' as mapBox;

class SymbolController {
  List<mapBox.Symbol> urgenciasSymbols;
  List<mapBox.Symbol> bomberosSymbols;
  List<mapBox.Symbol> carabinerosSymbols;
  
  bool showUrgencias;
  bool showBomberos;
  bool showCarabineros;
  

  SymbolController()
  {
    urgenciasSymbols = new List<mapBox.Symbol>();
    bomberosSymbols = new List<mapBox.Symbol>();
    carabinerosSymbols = new List<mapBox.Symbol>();
    showUrgencias = false;
    showBomberos = false;
    showCarabineros = false;
  }
  
}
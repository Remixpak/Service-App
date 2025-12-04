import 'package:flutter/material.dart';
import 'package:service_app/services/shared_preference_service.dart';

class AppData extends ChangeNotifier {
  final SharedPreferenceService _prefs = SharedPreferenceService();
  String _mensajeReparacion =
      "Hola {NOMBRE} 👋, tu reparación con N° {ORDEN} ya está disponible. ¡Gracias por preferirnos!";
  String _mensajeReserva =
      "Hola {NOMBRE}👋, tu reserva con N° {ORDEN} está lista para retiro. ¡Gracias por preferirnos!";

  bool _loaded = false;
  bool get loaded => _loaded;

  AppData() {
    loadData();
  }

  String get mensajeReparacion => _mensajeReparacion;
  String get mensajeReserva => _mensajeReserva;

  Future<void> loadData() async {
    _mensajeReparacion = await _prefs.getMensajeReparacion() ?? "";
    _mensajeReserva = await _prefs.getMensajeReserva() ?? "";

    _loaded = true;
    notifyListeners();
  }

  Future<void> setMensajeReparacion(String mensaje) async {
    _mensajeReparacion = mensaje;
    await _prefs.saveMensajeReparacion(mensaje);
    notifyListeners();
  }

  Future<void> setMensajeReserva(String mensaje) async {
    _mensajeReserva = mensaje;
    await _prefs.saveMensajeReserva(mensaje);
    notifyListeners();
  }
}

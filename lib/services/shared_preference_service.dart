import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  Future<void> saveMensajeReparacion(String mensaje) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mensaje_reparacion', mensaje);
  }

  Future<String?> getMensajeReparacion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('mensaje_reparacion') ??
        "Hola {NOMBRE} 👋, tu reparación con N° {ORDEN} ya está disponible. ¡Gracias por preferirnos!";
  }

  Future<void> saveMensajeReserva(String mensaje) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mensaje_reserva', mensaje);
  }

  Future<String?> getMensajeReserva() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('mensaje_reserva') ??
        "Hola {NOMBRE}👋, tu reserva con N° {ORDEN} está lista para retiro. ¡Gracias por preferirnos!";
  }
}

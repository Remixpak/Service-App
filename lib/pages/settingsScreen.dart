import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/l10n/app_localizations.dart';
import 'package:service_app/pages/login_register_page.dart';
import 'package:service_app/providers/auth_provider.dart';
import 'package:service_app/providers/App_Data.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController reparacionController;
  late TextEditingController reservaController;

  @override
  void initState() {
    super.initState();

    // Inicialmente strings vacíos → luego se llenan en build
    reparacionController = TextEditingController();
    reservaController = TextEditingController();
  }

  @override
  void dispose() {
    reparacionController.dispose();
    reservaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final appData = Provider.of<AppData>(context);
    String sign = AppLocalizations.of(context)!.signIn;
    String register = AppLocalizations.of(context)!.register;
    // Esperar a que AppData cargue desde SharedPreferences
    if (!appData.loaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Setear texto solo la primera vez
    reparacionController.text = appData.mensajeReparacion;
    reservaController.text = appData.mensajeReserva;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                //───────────────────────────────────────────────
                //   CAMPO: MENSAJE DE REPARACIÓN
                //───────────────────────────────────────────────
                Text(
                  AppLocalizations.of(context)!.repairMessage,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: reparacionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText:
                        AppLocalizations.of(context)!.deliveryRepairMessage,
                  ),
                  onChanged: (value) {
                    appData.setMensajeReparacion(value);
                  },
                ),

                const SizedBox(height: 30),

                //───────────────────────────────────────────────
                //   CAMPO: MENSAJE DE RESERVA
                //───────────────────────────────────────────────
                Text(
                  AppLocalizations.of(context)!.reserveMessage,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: reservaController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: AppLocalizations.of(context)!.confirmReserve,
                  ),
                  onChanged: (value) {
                    appData.setMensajeReserva(value);
                  },
                ),

                const SizedBox(height: 40),

                //───────────────────────────────────────────────
                //       SI HAY USUARIO → MOSTRAR INFO Y LOGOUT
                //───────────────────────────────────────────────
                if (auth.appUser != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    AppLocalizations.of(context)!.currentUser,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(auth.appUser!.email,
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      await auth.logout();

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  AppLocalizations.of(context)!.closedAccount)),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)!.closeSession,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],

                //───────────────────────────────────────────────
                //     SI NO HAY USUARIO → MOSTRAR LOGIN BUTTON
                //───────────────────────────────────────────────
                if (auth.appUser == null) ...[
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LoginRegisterPage()),
                      );
                    },
                    child: Text(
                      "$sign / $register",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

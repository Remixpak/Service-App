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
    reparacionController = TextEditingController();
    reservaController = TextEditingController();
  }

  @override
  void dispose() {
    reparacionController.dispose();
    reservaController.dispose();
    super.dispose();
  }

  Widget buildSectionTitle(String text, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 3,
          width: 50,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }

  InputDecoration inputDecoration(String hint, Color primaryColor) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final appData = Provider.of<AppData>(context);
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    final primaryColor = color.primary;
    final sign = AppLocalizations.of(context)!.signIn;
    final register = AppLocalizations.of(context)!.register;

    if (!appData.loaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    reparacionController.text = appData.mensajeReparacion;
    reservaController.text = appData.mensajeReserva;

    return Scaffold(
      backgroundColor: color.surfaceVariant,
      appBar: AppBar(
        backgroundColor: color.inversePrimary,
        elevation: 0,
        title: Text(AppLocalizations.of(context)!.settings),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: color.outline,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSectionTitle(
                    AppLocalizations.of(context)!.repairMessage, primaryColor),
                const SizedBox(height: 12),
                TextField(
                  controller: reparacionController,
                  maxLines: 3,
                  decoration: inputDecoration(
                    AppLocalizations.of(context)!.deliveryRepairMessage,
                    primaryColor,
                  ),
                  onChanged: (v) => appData.setMensajeReparacion(v),
                ),
                const SizedBox(height: 35),
                buildSectionTitle(
                    AppLocalizations.of(context)!.reserveMessage, primaryColor),
                const SizedBox(height: 12),
                TextField(
                  controller: reservaController,
                  maxLines: 3,
                  decoration: inputDecoration(
                    AppLocalizations.of(context)!.confirmReserve,
                    primaryColor,
                  ),
                  onChanged: (v) => appData.setMensajeReserva(v),
                ),
                const SizedBox(height: 40),
                if (auth.appUser != null) ...[
                  buildSectionTitle(
                      AppLocalizations.of(context)!.currentUser, primaryColor),
                  const SizedBox(height: 10),
                  Text(
                    auth.appUser!.email,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color.tertiary,
                        foregroundColor: color.onTertiary,
                        elevation: 1.5,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 20),
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
                                  AppLocalizations.of(context)!.closedAccount),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context)!.closeSession,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
                if (auth.appUser == null) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color.primary,
                        foregroundColor: color.onPrimary,
                        elevation: 1.5,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: color.secondary, width: 1.5),
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
                        style: const TextStyle(fontSize: 18),
                      ),
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

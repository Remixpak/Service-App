//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/pages/consultarVoucher.dart';
import 'package:service_app/providers/auth_provider.dart';
import 'package:service_app/pages/voucherScreen.dart';
import 'package:service_app/l10n/app_localizations.dart';
import 'package:service_app/pages/settingsScreen.dart';
import 'package:service_app/services/connection_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool? hasConnection;
  @override
  void initState() {
    super.initState();
    checkConnectionStatus();
  }

  void toVoucherScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VoucherScreen()),
    );
  }

  void toConsultarVoucher() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Consultarvoucher()),
    );
  }

  void toSettingsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  Future<void> checkConnectionStatus() async {
    final online = await ConnectionService().checkOnline();
    setState(() {
      hasConnection = online;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (hasConnection == false) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Text(
            AppLocalizations.of(context)!.internetError,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      );
    }
    final auth = Provider.of<AuthProvider>(context);

    print("print usuario: ${auth.appUser?.email}");
    print("admin: ${auth.appUser?.admin}");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: AppLocalizations.of(context)!.settings,
            icon: const Icon(Icons.settings),
            onPressed: () {
              toSettingsScreen();
            },
          ),
        ],
      ),

      // ─────────────────────────────────────────────────────────────
      //                 BODY: LOADER O BOTONES
      // ─────────────────────────────────────────────────────────────
      body: Center(
        child: (auth.appUser == null)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: toConsultarVoucher,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 36,
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: Text(AppLocalizations.of(context)!.query),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: toConsultarVoucher,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 36, vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: Text(AppLocalizations.of(context)!.query),
                  ),
                  const SizedBox(height: 20),
                  if (auth.appUser?.admin == true)
                    ElevatedButton(
                      onPressed: toVoucherScreen,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 36,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: Text(AppLocalizations.of(context)!.issueVoucher),
                    ),
                ],
              ),
      ),
    );
  }
}

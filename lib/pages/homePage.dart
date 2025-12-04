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
    final outlineColor = Theme.of(context).colorScheme.secondary;

    if (hasConnection == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              height: 1,
              color: outlineColor,
            ),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (hasConnection == false) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              height: 1,
              color: outlineColor,
            ),
          ),
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: outlineColor, // línea bajo el AppBar
          ),
        ),
      ),
      body: Center(
        child: (auth.appUser == null)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/enterpriceLogo.png',
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: toConsultarVoucher,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 36,
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: outlineColor, // borde del botón
                          width: 2,
                        ),
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
            : SizedBox(
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(150),
                      child: Image.asset(
                        'assets/images/App-Service_icon.png',
                        width: 200,
                        height: 200,
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: toConsultarVoucher,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 36,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: outlineColor,
                            width: 2,
                          ),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.query_stats),
                          SizedBox(width: 8),
                          Text(AppLocalizations.of(context)!.query),
                        ],
                      ),
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
                            side: BorderSide(
                              color: outlineColor,
                              width: 2,
                            ),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.document_scanner),
                            SizedBox(width: 8),
                            Text(AppLocalizations.of(context)!.issueVoucher),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}

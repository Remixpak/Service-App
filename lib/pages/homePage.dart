import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:service_app/pages/login_register_page.dart';
import 'package:service_app/providers/auth_provider.dart';
import 'package:service_app/pages/voucherScreen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    print(dotenv.env['FOO']);
    if (auth.user == null) {
      //tambien podria se usar Provider.of<AuthProvider>(context).user
      return const LoginRegisterPage();
    } else {
      print("No user logged in");

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            IconButton(
              tooltip: 'Ajustes',
              icon: const Icon(Icons.settings),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Ajustes'),
                    content: const Text(
                      'Aquí irían las opciones de configuración.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cerrar'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),

        // ─────────────────────────────────────────────
        //                    BODY
        // ─────────────────────────────────────────────
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // BOTÓN NORMAL
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Consulta enviada al centro.'),
                    ),
                  );
                },
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
                child: const Text('Consulta'),
              ),

              const SizedBox(height: 20),

              // ─────────────────────────────────────────────
              // BOTÓN SOLO PARA ADMIN
              // ─────────────────────────────────────────────
              if (auth.appUser?.admin == true)
                ElevatedButton(
                  onPressed: () {
                    to_voucherScreen();
                  },
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
                  child: const Text('Emitir Voucher'),
                ),
            ],
          ),
        ),
      );
    }
  }

  void to_voucherScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VoucherScreen()),
    );
  }
}

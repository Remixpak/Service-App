import 'package:flutter/material.dart';
import 'package:service_app/l10n/app_localizations.dart';
import 'package:service_app/pages/emitirVoucher.dart';

class VoucherScreen extends StatelessWidget {
  const VoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Vouchers"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botón Emitir
            ElevatedButton(
              onPressed: () {
                to_emitirVoucher(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 18,
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: Text(AppLocalizations.of(context)!.issueVoucher),
            ),

            const SizedBox(height: 20),

            // Botón Editar
            ElevatedButton(
              onPressed: () {
                // Acción para editar voucher
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 18,
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text("Editar Voucher"),
            ),

            const SizedBox(height: 20),

            // Tercer botón (modifícalo si quieres)
            ElevatedButton(
              onPressed: () {
                // Otra acción
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 18,
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text("Eliminar voucher"),
            ),
          ],
        ),
      ),
    );
  }

  void to_emitirVoucher(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EmitirVoucherScreen()),
    );
  }
}

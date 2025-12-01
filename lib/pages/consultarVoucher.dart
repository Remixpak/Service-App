import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:service_app/l10n/app_localizations.dart';
import 'dart:io';
import '../services/pdf_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Consultarvoucher extends StatefulWidget {
  const Consultarvoucher({super.key});

  @override
  State<Consultarvoucher> createState() => _ConsultarvoucherState();
}

class _ConsultarvoucherState extends State<Consultarvoucher> {
  final TextEditingController idController = TextEditingController();

  Map<String, dynamic>? voucherData;
  bool loading = false;
  String? errorMessage;

  Future<bool> hasConnection() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  //Buscar voucher en Firestore
  Future<void> buscarVoucher() async {
    final id = idController.text.trim();

    if (id.isEmpty) {
      setState(() {
        errorMessage = AppLocalizations.of(context)!.enterId;
        voucherData = null;
      });
      return;
    }

    final connected = await hasConnection();
    if (!connected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.internetError),
        ),
      );
      return;
    }

    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final doc =
          await FirebaseFirestore.instance.collection("vouchers").doc(id).get();

      if (doc.exists) {
        setState(() {
          voucherData = doc.data();
          errorMessage = null;
        });
      } else {
        setState(() {
          voucherData = null;
          errorMessage = AppLocalizations.of(context)!.idError;
        });
      }
    } catch (e) {
      setState(() {
        voucherData = null;
        String queryError = AppLocalizations.of(context)!.queryError;
        errorMessage = '$queryError $e';
      });
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.queryVoucher),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              if (voucherData == null) return;

              // 1. Generar el PDF
              final pdfBytes = await PdfService.generateVoucherPdf(
                voucherData!,
              );

              // 2. Mostrar previsualización
              await Printing.layoutPdf(onLayout: (_) async => pdfBytes);

              // 3. Guardar archivo en Documentos
              final dir = await getApplicationDocumentsDirectory();
              final file = File("${dir.path}/voucher_${idController.text}.pdf");

              await file.writeAsBytes(pdfBytes);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.pdfSaved),
                  duration: const Duration(seconds: 3),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Campo para ingresar ID
            TextField(
              controller: idController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.voucherId,
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: buscarVoucher,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Botón Buscar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: buscarVoucher,
                child: Text(AppLocalizations.of(context)!.search),
              ),
            ),

            const SizedBox(height: 20),

            /// Cargando
            if (loading) const CircularProgressIndicator(),

            /// Error
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),

            /// Mostrar datos del voucher
            if (voucherData != null)
              Expanded(
                child: ListView(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.voucherData,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...voucherData!.entries.map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "${e.key}: ${e.value}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../services/pdf_service.dart';

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

  //Buscar voucher en Firestore
  Future<void> buscarVoucher() async {
    final id = idController.text.trim();

    if (id.isEmpty) {
      setState(() {
        errorMessage = "Debe ingresar un ID";
        voucherData = null;
      });
      return;
    }

    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final doc = await FirebaseFirestore.instance
          .collection("vouchers")
          .doc(id)
          .get();

      if (doc.exists) {
        setState(() {
          voucherData = doc.data();
          errorMessage = null;
        });
      } else {
        setState(() {
          voucherData = null;
          errorMessage = "No existe un voucher con ese ID";
        });
      }
    } catch (e) {
      setState(() {
        voucherData = null;
        errorMessage = "Error al consultar: $e";
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
        title: const Text('Consultar Voucher'),

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
                  content: Text("PDF guardado en Documentos"),
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
                labelText: "ID del voucher",
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
                child: const Text("Buscar"),
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
                      "📄 Datos del Voucher",
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

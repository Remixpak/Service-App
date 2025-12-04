import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:service_app/l10n/app_localizations.dart';
import 'dart:io';
import '../services/pdf_service.dart';
import '../services/connection_service.dart';
import '../../models/voucher.dart';

class Consultarvoucher extends StatefulWidget {
  const Consultarvoucher({super.key});

  @override
  State<Consultarvoucher> createState() => _ConsultarvoucherState();
}

class _ConsultarvoucherState extends State<Consultarvoucher> {
  final TextEditingController ordenController = TextEditingController();

  Voucher? voucher;
  bool loading = false;
  String? errorMessage;
  late BuildContext scaffoldContext;

  /// Buscar voucher por número de orden
  Future<void> buscarVoucher() async {
    String searchError = AppLocalizations.of(context)!.searchError;
    final numeroOrden = ordenController.text.trim();

    if (numeroOrden.isEmpty) {
      setState(() {
        errorMessage = AppLocalizations.of(context)!.enterOrderNumber;
        voucher = null;
      });
      return;
    }

    final online = await ConnectionService().checkOnline();
    if (!online) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.internetError)),
      );
      return;
    }

    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final query = await FirebaseFirestore.instance
          .collection("vouchers")
          .where("numeroOrden", isEqualTo: numeroOrden)
          .get();

      if (query.docs.isEmpty) {
        setState(() {
          voucher = null;
          errorMessage = AppLocalizations.of(context)!.orderError;
        });
      } else {
        setState(() {
          voucher = Voucher.fromMap(query.docs.first.data());
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "$searchError $e";
        voucher = null;
      });
    }

    setState(() {
      loading = false;
    });
  }

  /// Formateo de fecha
  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    scaffoldContext = context;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.queryVoucher),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              if (voucher == null) return;

              final pdfBytes = await PdfService.generateVoucherPdf(
                voucher!.toMap(),
              );

              await Printing.layoutPdf(onLayout: (_) async => pdfBytes);

              final dir = await getApplicationDocumentsDirectory();
              final file = File(
                "${dir.path}/voucher_${voucher!.numeroOrden}.pdf",
              );

              await file.writeAsBytes(pdfBytes);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)!.pdfSaved)),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: ordenController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.orderNumber,
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: buscarVoucher,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: buscarVoucher,
                child: Text(AppLocalizations.of(context)!.search),
              ),
            ),
            const SizedBox(height: 20),
            if (loading) const CircularProgressIndicator(),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            if (voucher != null)
              Expanded(
                child: ListView(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.voucherData,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildItem("ID", voucher!.id),
                    buildItem("Número de orden", voucher!.numeroOrden),
                    buildItem("Cliente", voucher!.nombreCliente),
                    buildItem("Teléfono", voucher!.telefonoCliente),
                    buildItem("Descripción", voucher!.description),
                    buildItem("Modelo", voucher!.modelo),
                    buildItem("Servicio", voucher!.servicio),
                    buildItem("Emisor", voucher!.emisor),
                    buildItem(
                      "Fecha emisión",
                      formatDate(voucher!.fechaEmision),
                    ),
                    buildItem(
                      "Fecha entrega",
                      formatDate(voucher!.fechaEntrega),
                    ),
                    buildItem("Total", "\$${voucher!.total}"),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Widget para mostrar datos formateados
  Widget buildItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text("$label: $value", style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}

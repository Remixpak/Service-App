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

  Future<void> buscarVoucher() async {
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
        errorMessage = "${AppLocalizations.of(context)!.searchError} $e";
        voucher = null;
      });
    }

    setState(() => loading = false);
  }

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  InputDecoration inputDecoration(String label) {
    final cs = Theme.of(context).colorScheme;
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: cs.background,
      labelStyle: TextStyle(color: cs.onBackground.withOpacity(0.8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cs.secondary, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cs.secondary, width: 2),
      ),
      suffixIconColor: cs.secondary,
    );
  }

  ButtonStyle elevatedButtonStyle() {
    final cs = Theme.of(context).colorScheme;
    return ElevatedButton.styleFrom(
      backgroundColor: cs.background,
      foregroundColor: cs.secondary,
      side: BorderSide(color: cs.secondary, width: 2),
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.queryVoucher),
        centerTitle: true,
        backgroundColor: cs.inversePrimary,
        foregroundColor: cs.onInverseSurface,
        elevation: 1,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: cs.secondary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: voucher == null
                ? null
                : () async {
                    final pdfBytes =
                        await PdfService.generateVoucherPdf(voucher!.toMap());
                    await Printing.layoutPdf(onLayout: (_) async => pdfBytes);

                    final dir = await getApplicationDocumentsDirectory();
                    final file =
                        File("${dir.path}/voucher_${voucher!.numeroOrden}.pdf");
                    await file.writeAsBytes(pdfBytes);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text(AppLocalizations.of(context)!.pdfSaved)),
                    );
                  },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: ordenController,
              decoration: inputDecoration(
                AppLocalizations.of(context)!.orderNumber,
              ).copyWith(
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
                style: elevatedButtonStyle(),
                child: Text(AppLocalizations.of(context)!.search),
              ),
            ),
            const SizedBox(height: 20),
            if (loading) CircularProgressIndicator(color: cs.secondary),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: TextStyle(
                  color: cs.secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
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
                        color: cs.secondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...[
                      buildItem("ID", voucher!.id),
                      buildItem("Número de orden", voucher!.numeroOrden),
                      buildItem("Cliente", voucher!.nombreCliente),
                      buildItem("Teléfono", voucher!.telefonoCliente),
                      buildItem("Descripción", voucher!.description),
                      buildItem("Modelo", voucher!.modelo),
                      buildItem("Servicio", voucher!.servicio),
                      buildItem("Emisor", voucher!.emisor),
                      buildItem(
                          "Fecha emisión", formatDate(voucher!.fechaEmision)),
                      buildItem(
                          "Fecha entrega", formatDate(voucher!.fechaEntrega)),
                      buildItem("Total", "\$${voucher!.total}"),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(String label, String value) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.secondary, width: 2),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Text(
          "$label: $value",
          style: TextStyle(
            fontSize: 16,
            color: cs.onBackground,
          ),
        ),
      ),
    );
  }
}

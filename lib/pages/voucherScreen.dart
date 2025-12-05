import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:service_app/l10n/app_localizations.dart';
import 'package:service_app/pages/EditVoucherScreen.dart';
import 'package:service_app/pages/emitirVoucher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:service_app/models/voucher.dart';
import 'package:service_app/providers/App_Data.dart';
import 'package:provider/provider.dart';
import 'package:service_app/services/pdf_service.dart';
import 'package:service_app/services/share_service.dart';

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({super.key});

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  String? expandedId;

  String mensajeReparacion(BuildContext context, String nombre, String orden) {
    final appData = Provider.of<AppData>(context, listen: false);
    return appData.mensajeReparacion
        .replaceAll("{NOMBRE}", nombre)
        .replaceAll("{ORDEN}", orden);
  }

  String mensajeReserva(BuildContext context, String nombre, String orden) {
    final appData = Provider.of<AppData>(context, listen: false);
    return appData.mensajeReserva
        .replaceAll("{NOMBRE}", nombre)
        .replaceAll("{ORDEN}", orden);
  }

  Future<void> enviarMensajeWhatsapp(String telefono, String mensaje) async {
    final cleanPhone = telefono.replaceAll(RegExp(r'\D'), '');
    final clPhone = cleanPhone.startsWith("56") ? cleanPhone : "56$cleanPhone";

    final url = Uri.parse(
      "https://wa.me/$clPhone?text=${Uri.encodeComponent(mensaje)}",
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.whatsappError)),
      );
    }
  }

  Future<void> compartirPdf(Voucher voucher) async {
    final ctx = context;
    try {
      final pdfBytes = await PdfService.generateVoucherPdf({
        "id": voucher.id,
        "numeroOrden": voucher.numeroOrden,
        "nombreCliente": voucher.nombreCliente,
        "telefonoCliente": voucher.telefonoCliente,
        "description": voucher.description,
        "emisor": voucher.emisor,
        "fechaEmision": voucher.fechaEmision,
        "fechaEntrega": voucher.fechaEntrega,
        "modelo": voucher.modelo,
        "servicio": voucher.servicio,
        "total": voucher.total,
      });

      final filePath = await ShareService.savePdfTemp(
        pdfBytes,
        "voucher_${voucher.id}.pdf",
      );

      await ShareService.sharePdf(filePath);
    } catch (e) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text("${AppLocalizations.of(ctx)!.pdfError} $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    String order = AppLocalizations.of(context)!.order;
    String client = AppLocalizations.of(context)!.client;
    String model = AppLocalizations.of(context)!.model;
    String service = AppLocalizations.of(context)!.service;

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        title: const Text("Vouchers"),
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context)!.issueVoucher),
        backgroundColor: cs.secondary,
        foregroundColor: cs.onSecondary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EmitirVoucherScreen()),
          );
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("vouchers")
            .orderBy("fechaEmision", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(color: cs.primary));
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.noVouchersRegistered,
                style: TextStyle(fontSize: 18, color: cs.onBackground),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final v = docs[index];
              final String id = v.id;

              final data = v.data() as Map<String, dynamic>;
              final numero = data["numeroOrden"] ?? "---";
              final cliente = data["nombreCliente"] ?? "Sin nombre";
              final modelo = data["modelo"] ?? "Sin modelo";
              final telefono = data["telefonoCliente"] ?? "";
              final servicio = data["servicio"] ?? "Sin servicio";

              final bool expanded = expandedId == id;
              final voucher = Voucher.fromMap({...data, "id": id});

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 12),
                child: Card(
                  color: cs.surface,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      setState(() {
                        expandedId = expanded ? null : id;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Cabecera
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "$order $numero",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: cs.primary,
                                ),
                              ),
                              Icon(
                                expanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: 28,
                                color: cs.secondary,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "$client $cliente",
                            style: TextStyle(fontSize: 16, color: cs.onSurface),
                          ),
                          Text(
                            "$model $modelo",
                            style: TextStyle(fontSize: 16, color: cs.onSurface),
                          ),
                          Text(
                            "$service $servicio",
                            style: TextStyle(fontSize: 16, color: cs.outline),
                          ),

                          // Expansión
                          if (expanded) ...[
                            const Divider(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.send,
                                    color: cs.secondary,
                                    size: 28,
                                  ),
                                  onPressed: () {
                                    final mensaje =
                                        servicio ==
                                            AppLocalizations.of(
                                              context,
                                            )!.repairMessage
                                        ? mensajeReparacion(
                                            context,
                                            cliente,
                                            numero,
                                          )
                                        : mensajeReserva(
                                            context,
                                            cliente,
                                            numero,
                                          );
                                    enviarMensajeWhatsapp(telefono, mensaje);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.share,
                                    color: cs.primary,
                                    size: 28,
                                  ),
                                  onPressed: () {
                                    compartirPdf(voucher);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: cs.primary,
                                    size: 28,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            EditVoucherScreen(voucher: voucher),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: cs.error,
                                    size: 28,
                                  ),
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection("vouchers")
                                        .doc(id)
                                        .delete();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

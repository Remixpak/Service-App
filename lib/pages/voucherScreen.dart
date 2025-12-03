import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:service_app/pages/EditVoucherScreen.dart';
import 'package:service_app/pages/emitirVoucher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:service_app/models/voucher.dart';
import 'package:service_app/providers/App_Data.dart';
import 'package:provider/provider.dart';

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({super.key});

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  /// Para controlar qué card está expandido
  String? expandedId;

  /// Mensajes por defecto
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

  /// Abrir WhatsApp con mensaje
  Future<void> enviarMensajeWhatsapp(String telefono, String mensaje) async {
    final cleanPhone = telefono.replaceAll(RegExp(r'\D'), '');
    final clPhone = cleanPhone.startsWith("56") ? cleanPhone : "56$cleanPhone";

    final url = Uri.parse(
        "https://wa.me/$clPhone?text=${Uri.encodeComponent(mensaje)}");

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo abrir WhatsApp")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vouchers"),
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Emitir Voucher"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const EmitirVoucherScreen(),
            ),
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
            return const Center(
                child: CircularProgressIndicator(color: Colors.blue));
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "No hay vouchers registrados",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final v = docs[index];
              final String id = v.id;

              /// ---------- LECTURA DE DATOS SEGURA ----------
              final data = v.data() as Map<String, dynamic>;

              final numero = data["numeroOrden"] ?? "---";
              final cliente = data["nombreCliente"] ?? "Sin nombre";
              final modelo = data["modelo"] ?? "Sin modelo";
              final telefono = data["telefonoCliente"] ?? "";
              final servicio = data["servicio"] ?? "Sin servicio";

              final bool expanded = expandedId == id;

              final voucher = Voucher.fromMap({
                ...data,
                "id": id,
              });

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 12),
                child: Card(
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
                          /// --------- CABECERA ----------
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Orden: $numero",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                expanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: 28,
                              ),
                            ],
                          ),

                          const SizedBox(height: 4),

                          Text("Cliente: $cliente",
                              style: const TextStyle(fontSize: 16)),
                          Text("Modelo: $modelo",
                              style: const TextStyle(fontSize: 16)),
                          Text("Servicio: $servicio",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.grey)),

                          /// --------- EXPANSIÓN ----------
                          if (expanded) ...[
                            const Divider(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                /// 🟩 Enviar mensaje
                                IconButton(
                                  icon: const Icon(Icons.send,
                                      color: Colors.green, size: 30),
                                  onPressed: () {
                                    final mensaje = servicio == "Reparación"
                                        ? mensajeReparacion(
                                            context, cliente, numero)
                                        : mensajeReserva(
                                            context, cliente, numero);

                                    enviarMensajeWhatsapp(telefono, mensaje);
                                  },
                                ),

                                /// EDITAR
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue, size: 30),
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

                                /// Eliminar
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red, size: 30),
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection("vouchers")
                                        .doc(id)
                                        .delete();
                                  },
                                ),
                              ],
                            )
                          ]
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

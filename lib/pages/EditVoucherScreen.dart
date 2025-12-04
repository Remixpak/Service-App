import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:service_app/l10n/app_localizations.dart';
import 'package:service_app/models/voucher.dart';

class EditVoucherScreen extends StatefulWidget {
  final Voucher voucher;

  const EditVoucherScreen({super.key, required this.voucher});

  @override
  State<EditVoucherScreen> createState() => _EditVoucherScreenState();
}

class _EditVoucherScreenState extends State<EditVoucherScreen> {
  late TextEditingController numeroOrdenController;
  late TextEditingController nombreClienteController;
  late TextEditingController telefonoClienteController;
  late TextEditingController descriptionController;
  late TextEditingController emisorController;
  late TextEditingController totalController;

  late DateTime fechaEmision;
  late DateTime fechaEntrega;

  String modeloSeleccionado = "Otro";
  String servicioSeleccionado = "Reparación";

  bool saving = false;

  @override
  void initState() {
    super.initState();

    // Rellenar controladores con el voucher recibido
    numeroOrdenController =
        TextEditingController(text: widget.voucher.numeroOrden);
    nombreClienteController =
        TextEditingController(text: widget.voucher.nombreCliente);
    telefonoClienteController =
        TextEditingController(text: widget.voucher.telefonoCliente);
    descriptionController =
        TextEditingController(text: widget.voucher.description);
    emisorController = TextEditingController(text: widget.voucher.emisor);
    totalController =
        TextEditingController(text: widget.voucher.total.toString());

    fechaEmision = widget.voucher.fechaEmision;
    fechaEntrega = widget.voucher.fechaEntrega;

    modeloSeleccionado = widget.voucher.modelo;
    servicioSeleccionado = widget.voucher.servicio;
  }

  Future<void> guardarCambios() async {
    String saveError = AppLocalizations.of(context)!.saveError;
    setState(() => saving = true);

    try {
      final docRef = FirebaseFirestore.instance
          .collection("vouchers")
          .doc(widget.voucher.id);

      await docRef.update({
        "numeroOrden": numeroOrdenController.text.trim(),
        "nombreCliente": nombreClienteController.text.trim(),
        "telefonoCliente": telefonoClienteController.text.trim(),
        "description": descriptionController.text.trim(),
        "emisor": emisorController.text.trim(),
        "modelo": modeloSeleccionado,
        "servicio": servicioSeleccionado,
        "fechaEmision": fechaEmision.toIso8601String(),
        "fechaEntrega": fechaEntrega.toIso8601String(),
        "total": int.tryParse(totalController.text.trim()) ?? 0,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.editSucces)),
      );

      Navigator.pop(context); // volver atrás
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$saveError $e")),
      );
    }

    setState(() => saving = false);
  }

  Future<void> seleccionarFecha(bool esEmision) async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: esEmision ? fechaEmision : fechaEntrega,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (fecha != null) {
      setState(() {
        if (esEmision) {
          fechaEmision = fecha;
        } else {
          fechaEntrega = fecha;
        }
      });
    }
  }

  Widget buildInput(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String issueDate = AppLocalizations.of(context)!.issueDate;
    String deliveryDate = AppLocalizations.of(context)!.deliveryDate;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editingVoucher),
      ),
      body: saving
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  Text(
                    AppLocalizations.of(context)!.editData,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  buildInput("Número de orden", numeroOrdenController,
                      type: TextInputType.number),
                  buildInput("Nombre del cliente", nombreClienteController),
                  buildInput("Teléfono", telefonoClienteController,
                      type: TextInputType.phone),
                  buildInput("Descripción", descriptionController),
                  buildInput("Emisor", emisorController),
                  buildInput("Total", totalController,
                      type: TextInputType.number),

                  const SizedBox(height: 10),

                  // Modelo
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.model,
                      border: OutlineInputBorder(),
                    ),
                    value: modeloSeleccionado,
                    items: Voucher.modelosDisponibles
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => modeloSeleccionado = v);
                    },
                  ),

                  const SizedBox(height: 10),

                  // Servicio
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.service,
                      border: OutlineInputBorder(),
                    ),
                    value: servicioSeleccionado,
                    items: Voucher.serviciosDisponibles
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => servicioSeleccionado = v);
                    },
                  ),

                  const SizedBox(height: 10),

                  // Fecha emisión
                  ListTile(
                    title: Text(
                        "$issueDate ${fechaEmision.day}/${fechaEmision.month}/${fechaEmision.year}"),
                    trailing: const Icon(Icons.calendar_month),
                    onTap: () => seleccionarFecha(true),
                  ),
                  const SizedBox(height: 10),

                  // Fecha entrega
                  ListTile(
                    title: Text(
                        "$deliveryDate ${fechaEntrega.day}/${fechaEntrega.month}/${fechaEntrega.year}"),
                    trailing: const Icon(Icons.calendar_month),
                    onTap: () => seleccionarFecha(false),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: guardarCambios,
                      icon: const Icon(Icons.save),
                      label: Text(AppLocalizations.of(context)!.saveChanges),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

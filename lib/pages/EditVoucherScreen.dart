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
  String estadoSeleccionado = "Pendiente";

  bool saving = false;

  @override
  void initState() {
    super.initState();
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
    estadoSeleccionado = widget.voucher.estado;
  }

  Future<void> guardarCambios() async {
    final cs = Theme.of(context).colorScheme;
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
        "fechaEmision": Timestamp.fromDate(fechaEmision),
        "fechaEntrega": Timestamp.fromDate(fechaEntrega),
        "total": int.tryParse(totalController.text.trim()) ?? 0,
        "estado": estadoSeleccionado,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.editSucces)),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${AppLocalizations.of(context)!.saveError} $e"),
        ),
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
        if (esEmision)
          fechaEmision = fecha;
        else
          fechaEntrega = fecha;
      });
    }
  }

  Widget inputField(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text}) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: cs.primary)),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.secondary, width: 2),
          ),
          child: TextField(
            controller: controller,
            keyboardType: type,
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget dropdownField(String label, String value, List<String> options,
      void Function(String) onChanged) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: cs.primary)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.secondary, width: 2),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              items: options
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
            ),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    String issueDate = AppLocalizations.of(context)!.issueDate;
    String deliveryDate = AppLocalizations.of(context)!.deliveryDate;

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editingVoucher),
        backgroundColor: cs.inversePrimary,
        foregroundColor: cs.onInverseSurface,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: cs.secondary),
        ),
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
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: cs.primary),
                  ),
                  Container(
                    height: 3,
                    width: 60,
                    margin: const EdgeInsets.only(top: 4, bottom: 20),
                    color: cs.secondary,
                  ),
                  inputField("Número de orden", numeroOrdenController,
                      type: TextInputType.number),
                  inputField("Nombre del cliente", nombreClienteController),
                  inputField("Teléfono", telefonoClienteController,
                      type: TextInputType.phone),
                  inputField("Descripción", descriptionController),
                  inputField("Emisor", emisorController),
                  inputField("Total", totalController,
                      type: TextInputType.number),
                  dropdownField(
                    AppLocalizations.of(context)!.model,
                    modeloSeleccionado,
                    Voucher.modelosDisponibles,
                    (v) => setState(() => modeloSeleccionado = v),
                  ),
                  dropdownField(
                    AppLocalizations.of(context)!.service,
                    servicioSeleccionado,
                    Voucher.serviciosDisponibles,
                    (v) => setState(() => servicioSeleccionado = v),
                  ),
                  dropdownField(
                    "Estado",
                    estadoSeleccionado,
                    ["Pendiente", "En proceso", "Finalizada"],
                    (v) => setState(() => estadoSeleccionado = v),
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    tileColor: cs.surface,
                    title: Text(
                      "$issueDate ${fechaEmision.day}/${fechaEmision.month}/${fechaEmision.year}",
                      style: TextStyle(
                          color: cs.primary, fontWeight: FontWeight.w500),
                    ),
                    trailing: Icon(Icons.calendar_month, color: cs.secondary),
                    onTap: () => seleccionarFecha(true),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    tileColor: cs.surface,
                    title: Text(
                      "$deliveryDate ${fechaEntrega.day}/${fechaEntrega.month}/${fechaEntrega.year}",
                      style: TextStyle(
                          color: cs.primary, fontWeight: FontWeight.w500),
                    ),
                    trailing: Icon(Icons.calendar_month, color: cs.secondary),
                    onTap: () => seleccionarFecha(false),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cs.background,
                        foregroundColor: cs.secondary,
                        side: BorderSide(color: cs.secondary, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: guardarCambios,
                      icon: Icon(Icons.save, color: cs.secondary),
                      label: Text(
                        AppLocalizations.of(context)!.saveChanges,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

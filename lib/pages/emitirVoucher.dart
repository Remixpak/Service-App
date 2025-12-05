import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/l10n/app_localizations.dart';
import 'package:service_app/models/voucher.dart';
import 'package:service_app/providers/auth_provider.dart';
import '../services/connection_service.dart';

class EmitirVoucherScreen extends StatefulWidget {
  const EmitirVoucherScreen({super.key});

  @override
  State<EmitirVoucherScreen> createState() => _EmitirVoucherScreenState();
}

class _EmitirVoucherScreenState extends State<EmitirVoucherScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController numeroOrdenController = TextEditingController();
  final TextEditingController totalController = TextEditingController();

  String modeloSeleccionado = Voucher.modelosDisponibles.first;
  String servicioSeleccionado = Voucher.serviciosDisponibles.first;

  late final String idVoucher;
  DateTime fechaEmision = DateTime.now();
  DateTime? fechaEntrega;

  @override
  void initState() {
    super.initState();
    final docRef = FirebaseFirestore.instance.collection("vouchers").doc();
    idVoucher = docRef.id;

    generarNumeroOrden().then((numOrden) {
      numeroOrdenController.text = numOrden;
    });
  }

  Future<bool> existeNumeroOrden(String num) async {
    final query = await FirebaseFirestore.instance
        .collection("vouchers")
        .where("numeroOrden", isEqualTo: num)
        .get();
    return query.docs.isNotEmpty;
  }

  Future<void> guardarVoucher() async {
    String noUser = AppLocalizations.of(context)!.noUsers;
    if (!_formKey.currentState!.validate()) return;

    final online = await ConnectionService().checkOnline();
    if (!online) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.internetError)),
      );
      return;
    }

    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.appUser == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $noUser")));
      return;
    }

    final emisor = auth.appUser!.name;
    final numeroOrden = numeroOrdenController.text.trim();
    if (await existeNumeroOrden(numeroOrden)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.voucherExist)),
      );
      return;
    }

    final totalParsed = int.tryParse(totalController.text.trim());
    if (totalParsed == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.validTotal)),
      );
      return;
    }

    final voucher = Voucher(
      id: idVoucher,
      numeroOrden: numeroOrden,
      nombreCliente: nombreController.text.trim(),
      telefonoCliente: telefonoController.text.trim(),
      description: descripcionController.text.trim(),
      emisor: emisor,
      fechaEmision: fechaEmision,
      fechaEntrega: fechaEntrega ?? fechaEmision,
      modelo: modeloSeleccionado,
      servicio: servicioSeleccionado,
      total: totalParsed,
    );

    try {
      await FirebaseFirestore.instance
          .collection("vouchers")
          .doc(idVoucher)
          .set(voucher.toMap());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.voucherSuccess)),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<String> generarNumeroOrden() async {
    final query = await FirebaseFirestore.instance
        .collection("vouchers")
        .orderBy("numeroOrden", descending: true)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      return "0001";
    }

    final ultimo = query.docs.first.data()["numeroOrden"] ?? "0000";

    //convierte a int (maneja casos donde no es número)
    int num = int.tryParse(ultimo) ?? 0;
    num++;

    //retorna con ceros a la izquierda (4 dígitos)
    return num.toString().padLeft(4, "0");
  }

  /*Future<void> enviarVoucher() async {
    if (!_formKey.currentState!.validate()) return;

    String pdfError = AppLocalizations.of(context)!.pdfError;
    final phone = telefonoController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.validPhone)),
      );
      return;
    }

    final data = {
      "id": idVoucher,
      "numeroOrden": numeroOrdenController.text.trim(),
      "nombreCliente": nombreController.text.trim(),
      "telefonoCliente": telefonoController.text.trim(),
      "description": descripcionController.text.trim(),
      "emisor": Provider.of<AuthProvider>(context, listen: false).appUser?.name,
      "fechaEmision": fechaEmision,
      "fechaEntrega": fechaEntrega ?? fechaEmision,
      "modelo": modeloSeleccionado,
      "servicio": servicioSeleccionado,
      "total": int.tryParse(totalController.text.trim()) ?? 0,
    };

    try {
      final pdfBytes = await PdfService.generateVoucherPdf(data);
      final filePath =
          await ShareService.savePdfTemp(pdfBytes, "voucher_$idVoucher.pdf");
      await ShareService.sharePdf(filePath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$pdfError $e")),
      );
    }
  }*/

  InputDecoration modernInput(
    String label, {
    Color? fillColor,
    Color? borderColor,
  }) {
    final cs = Theme.of(context).colorScheme;
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: fillColor ?? cs.surface,
      labelStyle: TextStyle(fontWeight: FontWeight.w500, color: cs.primary),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor ?? cs.secondary, width: 2),
      ),
    );
  }

  Widget fechaTile(
    String label,
    DateTime? fecha,
    VoidCallback onTap, {
    bool allowClear = false,
  }) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: cs.surface,
      title: Text(
        fecha == null
            ? "$label (${AppLocalizations.of(context)!.notDefined})"
            : "$label ${fecha.day}/${fecha.month}/${fecha.year}",
        style: TextStyle(color: cs.primary, fontWeight: FontWeight.w500),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_month, color: cs.secondary),
          if (allowClear)
            IconButton(
              icon: Icon(Icons.clear, color: cs.secondary),
              onPressed: () => setState(() => fechaEntrega = null),
            ),
        ],
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.issueVoucher),
        backgroundColor: cs.inversePrimary,
        foregroundColor: cs.onInverseSurface,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: cs.secondary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                AppLocalizations.of(context)!.voucherData,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: cs.primary,
                ),
              ),
              Container(
                height: 3,
                width: 60,
                margin: const EdgeInsets.only(top: 4, bottom: 20),
                color: cs.secondary,
              ),
              Text(
                "ID: $idVoucher",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: cs.primary,
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: numeroOrdenController,
                decoration: modernInput(
                  AppLocalizations.of(context)!.orderNumber,
                ),
                maxLength: 4,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return AppLocalizations.of(context)!.enterOrderNumber;
                  if (value.length != 4)
                    return AppLocalizations.of(context)!.fourDigits;
                  if (!RegExp(r'^[0-9]{4}$').hasMatch(value))
                    return AppLocalizations.of(context)!.justNumbers;
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: nombreController,
                decoration: modernInput(
                  AppLocalizations.of(context)!.clientName,
                ),
                validator: (value) => value!.isEmpty
                    ? AppLocalizations.of(context)!.clientName
                    : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: telefonoController,
                keyboardType: TextInputType.phone,
                decoration: modernInput(
                  AppLocalizations.of(context)!.clientPhone,
                ),
                validator: (value) => value!.isEmpty
                    ? AppLocalizations.of(context)!.enterPhone
                    : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: descripcionController,
                maxLines: 3,
                decoration: modernInput(
                  AppLocalizations.of(context)!.description,
                ),
                validator: (value) => value!.isEmpty
                    ? AppLocalizations.of(context)!.enterDescription
                    : null,
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: modeloSeleccionado,
                decoration: modernInput(AppLocalizations.of(context)!.model),
                items: Voucher.modelosDisponibles
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (v) => setState(() => modeloSeleccionado = v!),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: servicioSeleccionado,
                decoration: modernInput(AppLocalizations.of(context)!.service),
                items: Voucher.serviciosDisponibles
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => servicioSeleccionado = v!),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: totalController,
                keyboardType: TextInputType.number,
                decoration: modernInput("Total (CLP)"),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return AppLocalizations.of(context)!.enterTotal;
                  final parsed = int.tryParse(value);
                  if (parsed == null)
                    return AppLocalizations.of(context)!.validTotal;
                  if (parsed < 0)
                    return AppLocalizations.of(context)!.totalError;
                  return null;
                },
              ),
              const SizedBox(height: 14),
              fechaTile("Fecha Emisión", fechaEmision, () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: fechaEmision,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => fechaEmision = picked);
              }),
              const SizedBox(height: 10),
              fechaTile("Fecha Entrega", fechaEntrega, () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: fechaEntrega ?? fechaEmision,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => fechaEntrega = picked);
              }, allowClear: true),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: guardarVoucher,
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.saveVoucher,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              /*ElevatedButton.icon(
                onPressed: enviarVoucher,
                icon: Icon(Icons.share, color: cs.onSecondary),
                label: Text(AppLocalizations.of(context)!.send,
                    style: TextStyle(color: cs.onSecondary)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.secondary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}

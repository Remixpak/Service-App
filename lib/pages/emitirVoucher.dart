import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:service_app/l10n/app_localizations.dart';
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
  final TextEditingController emisorController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();

  final ConnectionService _connectionService = ConnectionService();

  late final String idVoucher;

  DateTime fechaEmision = DateTime.now();

  @override
  void initState() {
    super.initState();

    /// Cuando entras a la pantalla ya generamos el ID (sin crear el documento)
    final docRef = FirebaseFirestore.instance.collection("vouchers").doc();
    idVoucher = docRef.id;
  }

  Future<void> guardarVoucher() async {
    if (!_formKey.currentState!.validate()) return;

    final online = await ConnectionService().checkOnline();

    if (!online) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.internetError)),
      );
      return;
    }

    final voucherData = {
      'id': idVoucher,
      'nombreCliente': nombreController.text.trim(),
      'telefonoCliente': telefonoController.text.trim(),
      'description': descripcionController.text.trim(),
      'emisor': emisorController.text.trim(),
      'fechaEmision': fechaEmision.toIso8601String(),
      'estado': estadoController.text.trim(),
    };

    try {
      await FirebaseFirestore.instance
          .collection("vouchers")
          .doc(idVoucher)
          .set(voucherData);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.voucherSuccess)),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      String saveError = AppLocalizations.of(context)!.saveError;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("$saveError $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    String date = AppLocalizations.of(context)!.date;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.issueVoucher),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                AppLocalizations.of(context)!.voucherData,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              Text(
                AppLocalizations.of(context)!.voucherId,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(idVoucher),
              ),
              const SizedBox(height: 20),

              // Nombre cliente
              TextFormField(
                controller: nombreController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.clientName,
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty
                    ? AppLocalizations.of(context)!.enterName
                    : null,
              ),
              const SizedBox(height: 15),

              // Teléfono
              TextFormField(
                controller: telefonoController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.clientPhone,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty
                    ? AppLocalizations.of(context)!.enterPhone
                    : null,
              ),
              const SizedBox(height: 15),

              // Descripción
              TextFormField(
                controller: descripcionController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.description,
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) => value!.isEmpty
                    ? AppLocalizations.of(context)!.enterDescription
                    : null,
              ),
              const SizedBox(height: 15),

              // Emisor
              TextFormField(
                controller: emisorController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.issuer,
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty
                    ? AppLocalizations.of(context)!.enterIssuer
                    : null,
              ),
              const SizedBox(height: 15),

              // Estado
              TextFormField(
                controller: estadoController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.state,
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty
                    ? AppLocalizations.of(context)!.enterState
                    : null,
              ),
              const SizedBox(height: 20),

              // Fecha de emisión

              Row(
                children: [
                  Text(
                    "$date ${fechaEmision.toLocal().toString().split('.')[0]}",
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: fechaEmision,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => fechaEmision = picked);
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.changeDate),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Botón guardar
              ElevatedButton(
                onPressed: guardarVoucher,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: Text(AppLocalizations.of(context)!.saveVoucher),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

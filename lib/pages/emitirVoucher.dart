import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  /// 🔥 ID autogenerado por Firestore
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

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Voucher guardado con éxito")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error al guardar: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emitir Voucher"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Datos del Voucher",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              Text(
                "ID del Voucher:",
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
                decoration: const InputDecoration(
                  labelText: "Nombre del Cliente",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Ingrese el nombre" : null,
              ),
              const SizedBox(height: 15),

              // Teléfono
              TextFormField(
                controller: telefonoController,
                decoration: const InputDecoration(
                  labelText: "Teléfono del Cliente",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? "Ingrese el teléfono" : null,
              ),
              const SizedBox(height: 15),

              // Descripción
              TextFormField(
                controller: descripcionController,
                decoration: const InputDecoration(
                  labelText: "Descripción",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) =>
                    value!.isEmpty ? "Ingrese la descripción" : null,
              ),
              const SizedBox(height: 15),

              // Emisor
              TextFormField(
                controller: emisorController,
                decoration: const InputDecoration(
                  labelText: "Emisor (UID o nombre del admin)",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Ingrese el emisor" : null,
              ),
              const SizedBox(height: 15),

              // Estado
              TextFormField(
                controller: estadoController,
                decoration: const InputDecoration(
                  labelText: "Estado (Ej: emitido, pendiente...)",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Ingrese el estado" : null,
              ),
              const SizedBox(height: 20),

              // Fecha de emisión
              Row(
                children: [
                  Text("Fecha: ${fechaEmision.toLocal()}".split('.')[0]),
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
                    child: const Text("Cambiar fecha"),
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
                child: const Text("Guardar Voucher"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
  DateTime? fechaEntrega; // opcional

  @override
  void initState() {
    super.initState();

    final docRef = FirebaseFirestore.instance.collection("vouchers").doc();
    idVoucher = docRef.id;
  }

  /// ---------------------------
  /// VALIDAR QUE EL NÚMERO DE ORDEN SEA ÚNICO
  /// ---------------------------
  Future<bool> existeNumeroOrden(String num) async {
    final query = await FirebaseFirestore.instance
        .collection("vouchers")
        .where("numeroOrden", isEqualTo: num)
        .get();

    return query.docs.isNotEmpty;
  }

  Future<void> guardarVoucher() async {
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: No hay usuario autenticado")),
      );
      return;
    }

    final String emisor = auth.appUser!.name;

    // validar número de orden único
    final numeroOrden = numeroOrdenController.text.trim();
    if (await existeNumeroOrden(numeroOrden)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ya existe un voucher con este número de orden"),
        ),
      );
      return;
    }

    // parse total
    final totalText = totalController.text.trim();
    final int? totalParsed = int.tryParse(totalText);
    if (totalParsed == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("El total debe ser un número válido")),
      );
      return;
    }

    // si no hay fechaEntrega seleccionada, usar fechaEmision como valor por defecto
    final DateTime fechaEntregaFinal = fechaEntrega ?? fechaEmision;

    final voucher = Voucher(
      id: idVoucher,
      numeroOrden: numeroOrden,
      nombreCliente: nombreController.text.trim(),
      telefonoCliente: telefonoController.text.trim(),
      description: descripcionController.text.trim(),
      emisor: emisor,
      fechaEmision: fechaEmision,
      fechaEntrega: fechaEntregaFinal,
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
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              /// ID automático mostrado
              Text(
                AppLocalizations.of(context)!.voucherId,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

              /// Número de orden
              TextFormField(
                controller: numeroOrdenController,
                decoration: InputDecoration(
                  labelText: "Número de orden",
                  labelStyle: TextStyle(fontFamily: "Roboto"),
                  errorStyle: TextStyle(fontFamily: "Roboto"),
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontFamily: "Roboto"),
                keyboardType: TextInputType.number,
                maxLength: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ingrese el número de orden";
                  }
                  if (value.length != 4) {
                    return "El número debe tener 4 dígitos";
                  }
                  if (!RegExp(r'^[0-9]{4}$').hasMatch(value)) {
                    return "Ingrese solo números";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              /// Nombre
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: "Nombre cliente",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Ingrese el nombre" : null,
              ),
              const SizedBox(height: 15),

              /// Teléfono
              TextFormField(
                controller: telefonoController,
                decoration: const InputDecoration(
                  labelText: "Teléfono cliente",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? "Ingrese el teléfono" : null,
              ),
              const SizedBox(height: 15),

              /// Descripción
              TextFormField(
                controller: descripcionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Descripción",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Ingrese la descripción" : null,
              ),
              const SizedBox(height: 20),

              /// MODELO (Dropdown)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Modelo",
                  border: OutlineInputBorder(),
                ),
                value: modeloSeleccionado,
                items: Voucher.modelosDisponibles
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (value) => setState(() {
                  modeloSeleccionado = value!;
                }),
              ),
              const SizedBox(height: 20),

              /// SERVICIO (Dropdown)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Servicio",
                  border: OutlineInputBorder(),
                ),
                value: servicioSeleccionado,
                items: Voucher.serviciosDisponibles
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (value) => setState(() {
                  servicioSeleccionado = value!;
                }),
              ),
              const SizedBox(height: 20),

              /// TOTAL (numérico)
              TextFormField(
                controller: totalController,
                decoration: const InputDecoration(
                  labelText: "Total (CLP)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ingrese el total";
                  }
                  final parsed = int.tryParse(value);
                  if (parsed == null) return "Ingrese un número válido";
                  if (parsed < 0) return "El total no puede ser negativo";
                  return null;
                },
              ),

              const SizedBox(height: 20),

              /// Fecha emisión + Fecha entrega opcional
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("$date ${fechaEmision.toLocal()}".split('.')[0]),
                        const SizedBox(height: 6),
                        ElevatedButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: fechaEmision,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() => fechaEmision = picked);
                            }
                          },
                          child: Text("Cambiar fecha emisión"),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Fecha entrega (opcional)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(fechaEntrega == null
                            ? "Fecha entrega: (no definida)"
                            : "Fecha entrega: ${fechaEntrega!.toLocal()}"
                                .split('.')[0]),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: fechaEntrega ?? fechaEmision,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  setState(() => fechaEntrega = picked);
                                }
                              },
                              child: const Text("Seleccionar entrega"),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () {
                                setState(() => fechaEntrega = null);
                              },
                              child: const Text("Limpiar"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// Guardar
              ElevatedButton(
                onPressed: guardarVoucher,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  textStyle: const TextStyle(fontSize: 18),
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

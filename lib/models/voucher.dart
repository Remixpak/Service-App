import 'package:flutter/material.dart';

class Voucher {
  final String id;
  final String numeroOrden;
  final String nombreCliente;
  final String telefonoCliente;
  final String description;
  final String emisor;
  final DateTime fechaEmision;
  final DateTime fechaEntrega;
  final String modelo;
  final String servicio;
  final int total;

  Voucher({
    required this.id,
    required this.numeroOrden,
    required this.nombreCliente,
    required this.telefonoCliente,
    required this.description,
    required this.emisor,
    required this.fechaEmision,
    required this.fechaEntrega,
    required this.modelo,
    required this.servicio,
    required this.total,
  });

  // ------- Convertir a mapa para Firestore -------
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numeroOrden': numeroOrden,
      'nombreCliente': nombreCliente,
      'telefonoCliente': telefonoCliente,
      'description': description,
      'emisor': emisor,
      'fechaEmision': fechaEmision.toIso8601String(),
      'fechaEntrega': fechaEntrega.toIso8601String(),
      'modelo': modelo,
      'servicio': servicio,
      'total': total,
    };
  }

  // ------- Crear Voucher desde Firestore -------
  factory Voucher.fromMap(Map<String, dynamic> map) {
    return Voucher(
      id: map['id'] ?? '',
      numeroOrden: map['numeroOrden'] ?? '',
      nombreCliente: map['nombreCliente'] ?? '',
      telefonoCliente: map['telefonoCliente'] ?? '',
      description: map['description'] ?? '',
      emisor: map['emisor'] ?? '',
      fechaEmision: DateTime.parse(map['fechaEmision']),
      fechaEntrega: DateTime.parse(map['fechaEntrega']),
      modelo: map['modelo'] ?? 'Otro',
      servicio: map['servicio'] ?? '',
      total: map['total'] ?? 0,
    );
  }

  // ------- Listas de selección -------
  static List<String> modelosDisponibles = [
    'Ps3',
    'Ps4',
    'Ps5',
    'Nintendo Switch',
    'Nintendo Switch 2',
    '3DS/2DS',
    'Otro',
  ];

  static List<String> serviciosDisponibles = [
    'Reserva',
    'Reparación',
  ];
}

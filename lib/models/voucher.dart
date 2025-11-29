import 'package:flutter/material.dart';

class Voucher {
  final String id;
  final String nombreCliente;
  final String telefonoCiente;
  final String description;
  final double emisor;
  final DateTime fechaEmicion;
  final String estado;

  Voucher({
    required this.id,
    required this.nombreCliente,
    required this.telefonoCiente,
    required this.description,
    required this.emisor,
    required this.fechaEmicion,
    required this.estado,
  });

  Map<String, dynamic> toMap(Voucher voucher) {
    return {
      'id': id,
      'nombreCliente': nombreCliente,
      'telefonoCiente': telefonoCiente,
      'description': description,
      'emisor': emisor,
      'fechaEmicion': fechaEmicion.toIso8601String(),
      'estado': estado,
    };
  }

  Voucher toVoucher(Map<String, dynamic> map) {
    return Voucher(
      id: map['id'],
      nombreCliente: map['nombreCliente'],
      telefonoCiente: map['telefonoCiente'],
      description: map['description'],
      emisor: map['emisor'],
      fechaEmicion: DateTime.parse(map['fechaEmicion']),
      estado: map['estado'],
    );
  }
}

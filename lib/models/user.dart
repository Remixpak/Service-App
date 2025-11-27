import 'package:flutter/material.dart';

class User {
  final String id;
  final String email;
  final String name;
  final String phoneNumber;
  final bool admin;
  User({
    required this.id,
    required this.email,
    required this.name,
    required this.phoneNumber,
    this.admin = false,
  });
}

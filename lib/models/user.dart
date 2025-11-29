import 'package:flutter/material.dart';

class AppUser {
  final String id;
  final String email;
  final String name;
  final String phoneNumber;
  final bool admin;
  AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.phoneNumber,
    this.admin = false,
  });
}

Map<String, dynamic> userToMap(AppUser user) {
  //con esto vamos a guardar el usuario en Firestore
  return {
    'id': user.id,
    'email': user.email,
    'name': user.name,
    'phoneNumber': user.phoneNumber,
    'admin': user.admin,
  };
}

AppUser mapToUser(Map<String, dynamic> map) {
  return AppUser(
    id: map['id'],
    email: map['email'],
    name: map['name'],
    phoneNumber: map['phoneNumber'],
    admin: map['admin'] ?? false,
  );
}

/*factory AppUser.fromFirebaseUser(/* firebase_auth.User */ dynamic fbUser) {
    return AppUser(
      id: fbUser.uid,
      email: fbUser.email ?? '',
      name: fbUser.displayName ?? '',
      phoneNumber: fbUser.phoneNumber ?? '',
      admin: false,
    );
  }
}*/

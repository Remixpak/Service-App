import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:service_app/models/user.dart';
import 'package:service_app/services/connection_service.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  User? user; //el usuario actual pero del firebase auth
  AppUser? appUser; //el usuario de nuestra app con datos adicionales
  bool isLoading = false; // Para mostrar cargando en UI

  AuthProvider() {
    _auth.authStateChanges().listen((User? fbUser) async {
      user = fbUser;

      if (fbUser != null) {
        // cargar info del usuario desde Firestore
        await loadOrCreateUser(fbUser);
      } else {
        appUser = null;
      }

      notifyListeners(); //despues de cargar appUser
    });
  }

  // ────────────────────────────────────────────────
  // Cargar usuario desde Firestore o crearlo si no existe
  // ────────────────────────────────────────────────
  Future<String?> loadOrCreateUser(User fbUser) async {
    //verificar conexion
    final online = await ConnectionService().checkOnline();
    if (!online) {
      return "No hay conexión a Internet";
    }

    try {
      final doc = _db.collection("users").doc(fbUser.uid);
      final snapshot = await doc.get();

      if (!snapshot.exists) {
        appUser = AppUser(
          id: fbUser.uid,
          email: fbUser.email ?? "",
          name: fbUser.displayName ?? "",
          phoneNumber: fbUser.phoneNumber ?? "",
          admin: false,
        );

        await doc.set(userToMap(appUser!));
      } else {
        appUser = mapToUser(snapshot.data()!);
      }

      return null; // success
    } catch (e) {
      return "Error conectando a Firestore: $e";
    }
  }

  // ────────────────────────────────────────────────
  //                REGISTRO CON EMAIL
  // ────────────────────────────────────────────────
  Future<String?> registerWithEmail(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      final credentials = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final fbUser = credentials.user;
      if (fbUser != null) {
        await loadOrCreateUser(fbUser);
      }

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ────────────────────────────────────────────────
  //                LOGIN CON EMAIL
  // ────────────────────────────────────────────────
  Future<String?> loginWithEmail(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      final credentials = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final fbUser = credentials.user;
      if (fbUser != null) {
        await loadOrCreateUser(fbUser);
      }

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ────────────────────────────────────────────────
  //                LOGIN CON GOOGLE
  // ────────────────────────────────────────────────

  Future<String?> loginWithGoogle() async {
    try {
      isLoading = true;
      notifyListeners();

      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return "Cancelado por el usuario";

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final result = await _auth.signInWithCredential(credential);

      final fbUser = result.user;
      if (fbUser != null) {
        await loadOrCreateUser(fbUser);
      }

      return null;
    } catch (e) {
      return "Error al iniciar sesión con Google: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ────────────────────────────────────────────────
  // EDITAR USUARIO (Firestore)
  // ────────────────────────────────────────────────
  Future<void> updateUser({String? name, String? phoneNumber}) async {
    if (appUser == null) return;

    final updated = AppUser(
      id: appUser!.id,
      email: appUser!.email,
      name: name ?? appUser!.name,
      phoneNumber: phoneNumber ?? appUser!.phoneNumber,
      admin: appUser!.admin,
    );

    appUser = updated;

    await _db.collection("users").doc(updated.id).update(userToMap(updated));

    notifyListeners();
  }

  // ────────────────────────────────────────────────
  //                    LOG OUT
  // ────────────────────────────────────────────────
  Future<void> logout() async {
    await _auth.signOut();
    user = null;
    notifyListeners();
  }
}

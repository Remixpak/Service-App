import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? user; // El usuario actual
  bool isLoading = false; // Para mostrar cargando en UI

  AuthProvider() {
    // Escucha automáticamente los cambios del usuario
    _auth.authStateChanges().listen((User? user) {
      this.user = user;
      notifyListeners();
    });
  }

  // ────────────────────────────────────────────────
  //                REGISTRO CON EMAIL
  // ────────────────────────────────────────────────
  Future<String?> registerWithEmail(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return null; // Todo OK
    } on FirebaseAuthException catch (e) {
      return e.message; // Mensaje de error para mostrarlo en UI
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

      await _auth.signInWithEmailAndPassword(email: email, password: password);

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

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      await _auth.signInWithCredential(credential);

      return null;
    } catch (e) {
      return "Error al iniciar sesión con Google: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
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

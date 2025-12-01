import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_app/l10n/app_localizations.dart';
import 'package:service_app/pages/homePage.dart';
import 'package:service_app/providers/auth_provider.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    if (auth.user != null) {
      // Si ya está logueado, ir a HomePage
      return const MyHomePage(title: 'Service App');
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Autenticación"),
        centerTitle: true,
        bottom: TabBar(
          controller: tabController,
          tabs: [
            Tab(text: AppLocalizations.of(context)!.signIn),
            Tab(text: AppLocalizations.of(context)!.register),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [buildLogin(auth), buildRegister(auth)],
      ),
    );
  }

  // ------------------------------------------------------------
  // LOGIN UI
  // ------------------------------------------------------------
  Widget buildLogin(AuthProvider auth) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),

          // CORREO
          buildTextField(emailController, "Correo", Icons.email),

          const SizedBox(height: 15),

          // CONTRASEÑA
          buildTextField(
            passController,
            "Contraseña",
            Icons.lock,
            isPassword: true,
          ),

          const SizedBox(height: 25),

          // BOTÓN LOGIN
          ElevatedButton(
            onPressed: auth.isLoading
                ? null
                : () async {
                    final error = await auth.loginWithEmail(
                      emailController.text.trim(),
                      passController.text.trim(),
                    );

                    if (error != null) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(error)));
                    }
                  },
            style: elevatedButtonStyle(),
            child: auth.isLoading
                ? const CircularProgressIndicator()
                : Text(AppLocalizations.of(context)!.signIn),
          ),

          const SizedBox(height: 15),

          // GOOGLE LOGIN
          OutlinedButton.icon(
            onPressed: auth.isLoading
                ? null
                : () async {
                    final error = await auth.loginWithGoogle();
                    if (error != null) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(error)));
                    }
                  },
            icon: const Icon(Icons.login),
            label: const Text("Iniciar con Google"),
          ),

          const SizedBox(height: 30),

          // TEXTO “NO TIENES CUENTA?”
          Center(
            child: GestureDetector(
              onTap: () {
                tabController.animateTo(1);
              },
              child: const Text(
                "¿No tienes cuenta? Regístrate",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // REGISTER UI
  // ------------------------------------------------------------
  Widget buildRegister(AuthProvider auth) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),

          buildTextField(emailController, "Correo", Icons.email),

          const SizedBox(height: 15),

          buildTextField(
            passController,
            "Contraseña",
            Icons.lock,
            isPassword: true,
          ),

          const SizedBox(height: 25),

          ElevatedButton(
            onPressed: auth.isLoading
                ? null
                : () async {
                    final error = await auth.registerWithEmail(
                      emailController.text.trim(),
                      passController.text.trim(),
                    );

                    if (error != null) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(error)));
                    }
                  },
            style: elevatedButtonStyle(),
            child: auth.isLoading
                ? const CircularProgressIndicator()
                : Text(AppLocalizations.of(context)!.register),
          ),

          const SizedBox(height: 15),

          // GOOGLE REGISTER (MISMO MÉTODO)
          OutlinedButton.icon(
            onPressed: auth.isLoading
                ? null
                : () async {
                    final error = await auth.loginWithGoogle();
                    if (error != null) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(error)));
                    }
                  },
            icon: const Icon(Icons.person_add),
            label: const Text("Registrarse con Google"),
          ),

          const SizedBox(height: 30),

          Center(
            child: GestureDetector(
              onTap: () {
                tabController.animateTo(0);
              },
              child: const Text(
                "¿Ya tienes cuenta? Inicia Sesión",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // WIDGETS REUTILIZABLES
  // ------------------------------------------------------------
  Widget buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  ButtonStyle elevatedButtonStyle() {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    );
  }
}

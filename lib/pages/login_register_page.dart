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

  InputDecoration buildInputDecoration(String label, IconData icon) {
    final cs = Theme.of(context).colorScheme;

    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: cs.primary),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cs.secondary.withOpacity(0.4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cs.secondary, width: 2),
      ),
    );
  }

  ButtonStyle elevatedButtonStyle() {
    final cs = Theme.of(context).colorScheme;

    return ElevatedButton.styleFrom(
      backgroundColor: cs.primary,
      foregroundColor: cs.onPrimary,
      padding: const EdgeInsets.symmetric(vertical: 15),
      elevation: 2,
      shadowColor: cs.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cs.secondary, width: 1.4),
      ),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final cs = Theme.of(context).colorScheme;

    if (auth.user != null) {
      return const MyHomePage(title: 'Service App');
    }

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        elevation: 0.5,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.authentication),

        // Línea debajo del AppBar igual que en Home
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: tabController,
                  labelColor: cs.onPrimary,
                  indicatorPadding: const EdgeInsets.symmetric(horizontal: -10),
                  unselectedLabelColor: cs.onPrimary.withOpacity(0.7),
                  indicator: BoxDecoration(
                    color: cs.secondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  tabs: [
                    Tab(text: AppLocalizations.of(context)!.signIn),
                    Tab(text: AppLocalizations.of(context)!.register),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          buildLogin(auth),
          buildRegister(auth),
        ],
      ),
    );
  }

  // LOGIN UI ----------------------------------------------------------
  Widget buildLogin(AuthProvider auth) {
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!.signIn,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: cs.primary,
            ),
          ),
          Container(
            height: 3,
            width: 60,
            margin: const EdgeInsets.only(top: 4, bottom: 20),
            decoration: BoxDecoration(
              color: cs.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          TextField(
            controller: emailController,
            decoration: buildInputDecoration(
                AppLocalizations.of(context)!.mail, Icons.email),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: passController,
            obscureText: true,
            decoration: buildInputDecoration(
                AppLocalizations.of(context)!.password, Icons.lock),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: auth.isLoading
                ? null
                : () async {
                    final error = await auth.loginWithEmail(
                      emailController.text.trim(),
                      passController.text.trim(),
                    );
                    if (error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error)),
                      );
                    }
                  },
            style: elevatedButtonStyle(),
            child: auth.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(AppLocalizations.of(context)!.signIn),
          ),
          const SizedBox(height: 15),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: cs.secondary, width: 1.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: Icon(Icons.login, color: cs.primary),
            label: Text(
              AppLocalizations.of(context)!.googleSignIn,
              style: TextStyle(color: cs.primary),
            ),
            onPressed: auth.isLoading ? null : () => auth.loginWithGoogle(),
          ),
          const SizedBox(height: 25),
          GestureDetector(
            onTap: () => tabController.animateTo(1),
            child: Text(
              AppLocalizations.of(context)!.dontHaveAccount,
              style: TextStyle(
                color: cs.primary,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // REGISTER UI -------------------------------------------------------
  Widget buildRegister(AuthProvider auth) {
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!.register,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: cs.primary,
            ),
          ),
          Container(
            height: 3,
            width: 60,
            margin: const EdgeInsets.only(top: 4, bottom: 20),
            decoration: BoxDecoration(
              color: cs.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          TextField(
            controller: emailController,
            decoration: buildInputDecoration(
              AppLocalizations.of(context)!.mail,
              Icons.email,
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: passController,
            obscureText: true,
            decoration: buildInputDecoration(
              AppLocalizations.of(context)!.password,
              Icons.lock,
            ),
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error)),
                      );
                    }
                  },
            style: elevatedButtonStyle(),
            child: auth.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(AppLocalizations.of(context)!.register),
          ),
          const SizedBox(height: 15),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: cs.secondary, width: 1.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: auth.isLoading ? null : auth.loginWithGoogle,
            icon: Icon(Icons.person_add, color: cs.primary),
            label: Text(
              AppLocalizations.of(context)!.googleRegistry,
              style: TextStyle(color: cs.primary),
            ),
          ),
          const SizedBox(height: 25),
          GestureDetector(
            onTap: () => tabController.animateTo(0),
            child: Text(
              AppLocalizations.of(context)!.haveAccount,
              style: TextStyle(
                color: cs.primary,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:service_app/firebase_options.dart';
import 'package:service_app/Pages/homePage.dart';
import 'package:service_app/providers/App_Data.dart';
import 'package:provider/provider.dart';
import 'package:service_app/providers/auth_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF78B2BF);
    const accentDark = Color(0xFFBF3111);
    const accent = Color(0xFFD95448);
    const accentLight = Color(0xFFD97B73);
    const surfaceBg = Color(0xFFF2F2F2);

    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      primaryContainer: primaryColor.withOpacity(0.85),
      onPrimaryContainer: Colors.white,
      secondary: accent,
      onSecondary: Colors.white,
      secondaryContainer: accentLight,
      onSecondaryContainer: Colors.white,
      tertiary: accentDark,
      onTertiary: Colors.white,
      error: Colors.red.shade700,
      onError: Colors.white,
      background: surfaceBg,
      onBackground: Colors.black87,
      surface: Colors.white,
      onSurface: Colors.black87,
      surfaceVariant: surfaceBg,
      onSurfaceVariant: Colors.black54,
      outline: Colors.black26,
      shadow: Colors.black26,
      inversePrimary: primaryColor.withOpacity(0.9),
      inverseSurface: Colors.black87,
      onInverseSurface: Colors.white,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AppData()),
      ],
      child: MaterialApp(
        title: 'Service App',
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('es'),
        ],
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: colorScheme,
          scaffoldBackgroundColor: surfaceBg,
          appBarTheme: AppBarTheme(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            elevation: 1,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: colorScheme.onPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              elevation: 2,
              shadowColor: Colors.black.withOpacity(0.25),
            ),
          ),
        ),
        home: const MyHomePage(title: 'Service App'),
      ),
    );
  }
}

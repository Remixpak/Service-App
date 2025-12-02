import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareService {
  /// Guarda un PDF en el directorio temporal y devuelve la ruta completa del archivo.
  static Future<String> savePdfTemp(Uint8List bytes, String filename) async {
    final directory = await getTemporaryDirectory();
    final path = "${directory.path}/$filename";

    final file = File(path);
    await file.writeAsBytes(bytes);

    return path;
  }

  /// Comparte un PDF a través de WhatsApp o cualquier app disponible.
  static Future<void> sharePdf(String filePath) async {
    await Share.shareXFiles([
      XFile(filePath, mimeType: "application/pdf"),
    ]);
  }

  static Future<void> abrirWhatsapp(String phone) async {
    // Limpia el número, remueve espacios y guiones
    final sanitized = phone.replaceAll(RegExp(r'\D'), '');

    // Si no comienza con +56 entonces lo agregamos
    final clPhone = sanitized.startsWith('56') ? sanitized : '56$sanitized';

    final url = Uri.parse("https://wa.me/$clPhone");

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw "No se pudo abrir WhatsApp";
    }
  }
}

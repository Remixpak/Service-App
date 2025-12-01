import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfService {
  /// Genera un PDF con logo centrado y fuentes Unicode Roboto
  static Future<Uint8List> generateVoucherPdf(
    Map<String, dynamic> voucherData,
  ) async {
    final pdf = pw.Document();

    // Cargar logo desde assets
    final logoBytes = await rootBundle.load('assets/images/enterpriceLogo.png');
    final logo = pw.MemoryImage(logoBytes.buffer.asUint8List());

    // 🔤 Cargar fuentes Unicode
    final robotoRegular = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Roboto-Regular.ttf"),
    );

    final robotoBold = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Roboto-Bold.ttf"),
    );

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Logo centrado
              pw.Center(child: pw.Image(logo, width: 150)),
              pw.SizedBox(height: 30),

              pw.Center(
                child: pw.Text(
                  "COMPROBANTE DE VOUCHER",
                  style: pw.TextStyle(fontSize: 22, font: robotoBold),
                ),
              ),

              pw.SizedBox(height: 30),

              pw.Text(
                "Detalles del Voucher",
                style: pw.TextStyle(fontSize: 18, font: robotoBold),
              ),

              pw.SizedBox(height: 10),

              ...voucherData.entries.map(
                (e) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 6),
                  child: pw.Text(
                    "${e.key.toUpperCase()}: ${e.value}",
                    style: pw.TextStyle(fontSize: 14, font: robotoRegular),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}

import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:cloud_firestore/cloud_firestore.dart';

class PdfService {
  /// Genera un PDF con logo centrado y fuentes Unicode Roboto
  static Future<Uint8List> generateVoucherPdf(
    Map<String, dynamic> data,
  ) async {
    final pdf = pw.Document();

    // LOGO (si no existe, el MemoryImage fallará — mantén el asset si lo usas)
    final logoBytes = await rootBundle.load('assets/images/enterpriceLogo.png');
    final logo = pw.MemoryImage(logoBytes.buffer.asUint8List());

    // Fuentes
    final robotoRegular = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Roboto-Regular.ttf"),
    );

    final robotoBold = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Roboto-Bold.ttf"),
    );

    // Helper: obtener campo string probando múltiples claves y conversión segura
    String getString(List<String> keys, [String fallback = ""]) {
      for (final k in keys) {
        if (data.containsKey(k) && data[k] != null) {
          return data[k].toString();
        }
      }
      return fallback;
    }

    // Helper: obtener fecha (DateTime) desde distintos formatos (Timestamp, ISO string, DateTime)
    DateTime? getDate(List<String> keys) {
      for (final k in keys) {
        if (!data.containsKey(k) || data[k] == null) continue;
        final v = data[k];
        if (v is DateTime) return v;
        if (v is String) {
          try {
            return DateTime.parse(v);
          } catch (_) {}
        }
        // Firestore Timestamp
        if (v is Map && v.containsKey('_seconds')) {
          // Some serialized timestamp shapes — try to detect
          try {
            final seconds = v['_seconds'] as int;
            return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
          } catch (_) {}
        }
        try {
          // If actual Timestamp object (if you pass it directly)
          if (v.runtimeType.toString().contains('Timestamp')) {
            // Convert via toDate if possible
            final dt = (v as dynamic).toDate();
            if (dt is DateTime) return dt;
          }
        } catch (_) {}
      }
      return null;
    }

    // Normalizar/obtener los campos probando varias claves posibles
    final numeroOrden = getString(
        ['numeroOrden', 'numero_orden', 'orderNumber', 'order_number', 'id']);
    final idDoc = getString(['id', 'docId']);
    final nombre = getString(['nombreCliente', 'nombre', 'clientName', 'name']);
    final telefono =
        getString(['telefonoCliente', 'telefono', 'phone', 'clientPhone']);
    final descripcion = getString(['description', 'descripcion', 'desc']);
    final emisor = getString(['emisor', 'issuer', 'emitter']);
    final modelo = getString(['modelo', 'model']);
    final servicio = getString(['servicio', 'service']);
    final total = getString(['total', 'totalVenta', 'amount'], '0');

    final fechaEmision = getDate([
      'fechaEmision',
      'fecha_emision',
      'fechaEmisionIso',
      'fecha_emision_iso'
    ]);
    final fechaEntrega = getDate([
      'fechaEntrega',
      'fecha_entrega',
      'fechaEntregaIso',
      'fecha_entrega_iso'
    ]);

    String fmtDate(DateTime? d) {
      if (d == null) return '';
      return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    }

    // Decide qué mostrar como número de orden: preferir numeroOrden, si no usar idDoc
    final displayOrder = numeroOrden.isNotEmpty ? numeroOrden : idDoc;

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // LOGO CENTRADO
              pw.Center(child: pw.Image(logo, width: 150)),
              pw.SizedBox(height: 20),

              // TÍTULO con número de orden (no con el doc id salvo como fallback)
              pw.Center(
                child: pw.Text(
                  "N° ORDEN: $displayOrder",
                  style: pw.TextStyle(
                    font: robotoBold,
                    fontSize: 22,
                    color: PdfColor(0.35, 0.55, 0.70),
                  ),
                ),
              ),
              pw.SizedBox(height: 20),

              // FECHAS (derecha)
              pw.Row(
                children: [
                  pw.Expanded(child: pw.Container()), // espacio izq

                  pw.Container(
                    width: 260,
                    child: pw.Table(
                      border: pw.TableBorder.all(width: 1),
                      children: [
                        _row2("Fecha Emisión", fmtDate(fechaEmision),
                            robotoRegular),
                        _row2("Fecha Entrega", fmtDate(fechaEntrega),
                            robotoRegular),
                      ],
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 30),

              // TABLA PRINCIPAL (Nombre / Emisor / Teléfono / Modelo)
              pw.Table(
                border: pw.TableBorder.all(width: 1),
                columnWidths: {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FlexColumnWidth(2),
                  2: const pw.FlexColumnWidth(2),
                },
                children: [
                  _titleRow(["Nombre", "", "Emisor"], robotoBold),
                  _dataRow([nombre, "", emisor], robotoRegular),
                  _titleRow(["Teléfono", "", "Modelo"], robotoBold),
                  _dataRow([telefono, "", modelo], robotoRegular),
                ],
              ),

              pw.SizedBox(height: 20),

              // DESCRIPCIÓN
              pw.Text(
                "Descripción:",
                style: pw.TextStyle(
                  font: robotoBold,
                  fontSize: 18,
                  color: PdfColor(0.35, 0.55, 0.70),
                ),
              ),

              pw.Container(
                height: 150,
                width: double.infinity,
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Text(
                  descripcion,
                  style: pw.TextStyle(font: robotoRegular, fontSize: 14),
                ),
              ),

              pw.SizedBox(height: 20),

              // SERVICIO + TOTAL
              pw.Table(
                border: pw.TableBorder.all(width: 1),
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(2),
                },
                children: [
                  _titleRow(["Servicio", "Total de la venta"], robotoBold),
                  _dataRow([servicio, total], robotoRegular),
                ],
              ),

              pw.SizedBox(height: 20),

              // NOTA
              pw.Text(
                "Nota: este documento es su garantía, consérvelo. La garantía no cubre daños por maltrato a consolas o accesorios.\n"
                "Se entenderán abandonados todos los artículos al no ser retirados en el plazo de un año. Ley 19.496 Art. 42",
                style: pw.TextStyle(
                  font: robotoRegular,
                  color: PdfColor(0.35, 0.55, 0.70),
                  fontSize: 12,
                ),
              )
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  // ---------------------------------------------------------------------------
  // Helpers para filas de tablas
  // ---------------------------------------------------------------------------

  static pw.TableRow _row2(String left, String? right, pw.Font font) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(left, style: pw.TextStyle(font: font)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(right ?? "", style: pw.TextStyle(font: font)),
        ),
      ],
    );
  }

  static pw.TableRow _titleRow(List<String> titles, pw.Font font) {
    return pw.TableRow(
      children: titles.map((t) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            t,
            style: pw.TextStyle(
              font: font,
              color: PdfColor(0.35, 0.55, 0.70),
            ),
          ),
        );
      }).toList(),
    );
  }

  static pw.TableRow _dataRow(List<dynamic> values, pw.Font font) {
    return pw.TableRow(
      children: values.map((v) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            v?.toString() ?? "",
            style: pw.TextStyle(font: font),
          ),
        );
      }).toList(),
    );
  }
}

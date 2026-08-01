import 'dart:typed_data';

import 'package:feature_settings/domain/models/public_menu_models.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

/// Produces local exports from the stable public URL only. The owner
/// capability and catalog snapshot are never embedded in the QR, PNG, or PDF.
class PublicMenuExporter {
  const PublicMenuExporter();

  Future<void> shareQrPng(MenuPublication publication) async {
    final bytes = await _qrPng(publication.publicUrl);
    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile.fromData(
            bytes,
            name: 'agora-public-menu-qr.png',
            mimeType: 'image/png',
          ),
        ],
        fileNameOverrides: const ['agora-public-menu-qr.png'],
      ),
    );
  }

  Future<void> shareA4Poster(MenuPublication publication) async {
    final document = pw.Document();
    document.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Center(
          child: pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Text(
                'Scan to view our menu',
                style: pw.TextStyle(
                  fontSize: 30,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 28),
              pw.BarcodeWidget(
                barcode: pw.Barcode.qrCode(),
                data: publication.publicUrl,
                width: 300,
                height: 300,
              ),
              pw.SizedBox(height: 28),
              pw.Text(publication.publicUrl, textAlign: pw.TextAlign.center),
            ],
          ),
        ),
      ),
    );
    final bytes = await document.save();
    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile.fromData(
            bytes,
            name: 'agora-public-menu-poster.pdf',
            mimeType: 'application/pdf',
          ),
        ],
        fileNameOverrides: const ['agora-public-menu-poster.pdf'],
      ),
    );
  }

  Future<Uint8List> _qrPng(String url) async {
    final imageData = await QrPainter(
      data: url,
      version: QrVersions.auto,
    ).toImageData(1024);
    if (imageData == null) {
      throw const PublicMenuExportException('Could not generate the QR image.');
    }
    return imageData.buffer.asUint8List();
  }
}

class PublicMenuExportException implements Exception {
  const PublicMenuExportException(this.message);

  final String message;

  @override
  String toString() => message;
}

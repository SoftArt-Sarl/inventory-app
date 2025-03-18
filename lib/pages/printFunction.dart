import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> printInvoice() async {
  final pdf = pw.Document();

  // Charger les images avant de créer la page
  Uint8List? logoImage;
  Uint8List? paymentImage;

  try {
    final logoResponse = await NetworkAssetBundle(Uri.parse(
            'https://storage.googleapis.com/a1aa/image/QEEofiUwIntu6h1MQ_yPjv4QRxzyckaQIFptEznf8YA.jpg'))
        .load('');
    logoImage = logoResponse.buffer.asUint8List();
  } catch (e) {
    print('Erreur lors du chargement de l\'image du logo : $e');
  }

  try {
    final paymentResponse = await NetworkAssetBundle(Uri.parse(
            'https://storage.googleapis.com/a1aa/image/x912kkwvucGKJN8W_fSjroBQ_rR1zNMKwgfsfJVA-_k.jpg'))
        .load('');
    paymentImage = paymentResponse.buffer.asUint8List();
  } catch (e) {
    print('Erreur lors du chargement de l\'image de paiement : $e');
  }

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                if (logoImage != null)
                  pw.Image(pw.MemoryImage(logoImage), width: 100),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('FACTURE',
                        style: pw.TextStyle(
                            fontSize: 32, fontWeight: pw.FontWeight.bold)),
                    pw.Text('Facture No. 12345',
                        style: const pw.TextStyle(fontSize: 12)),
                    pw.Text('26 Juillet 2025',
                        style: const pw.TextStyle(fontSize: 12)),
                    pw.Text('14:30', style: const pw.TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 16),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    _buildTableHeader('Article'),
                    _buildTableHeader('Quantité'),
                    _buildTableHeader('Prix Unitaire'),
                    _buildTableHeader('Total'),
                  ],
                ),
                _buildTableRow('Nom de l\'article ici', '1', '215 FCFA', '215 FCFA'),
                _buildTableRow('Nom de l\'article ici', '2', '120 FCFA', '240 FCFA'),
                _buildTableRow('Nom de l\'article ici', '1', '130 FCFA', '130 FCFA'),
              ],
            ),
            pw.SizedBox(height: 16),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  _buildTotalRow('Sous-total', '585 FCFA'),
                  _buildTotalRow('Taxe (0%)', '0 FCFA'),
                  pw.Text('Total à payer',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 20)),
                  pw.Text('585 FCFA',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 20)),
                ],
              ),
            ),
            pw.SizedBox(height: 16),
            pw.Center(child: pw.Text('Merci pour votre achat !')),
            pw.SizedBox(height: 16),
            pw.Text('INFORMATIONS DE PAIEMENT',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
            pw.Text('Méthode de paiement : À la caisse ou via MyNita'),
            pw.SizedBox(height: 16),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Nom de votre entreprise'),
                    pw.Text(
                        '987 Rue QuelquePart, Toute Ville, Tout État 987655'),
                  ],
                ),
                if (paymentImage != null)
                  pw.Image(pw.MemoryImage(paymentImage), width: 100),
              ],
            ),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save());
}

pw.TableRow _buildTableRow(
    String article, String quantity, String unitPrice, String total) {
  return pw.TableRow(
    children: [
      _buildTableCell(article),
      _buildTableCell(quantity),
      _buildTableCell(unitPrice),
      _buildTableCell(total),
    ],
  );
}

pw.Widget _buildTableHeader(String text) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(8.0),
    child: pw.Text(text, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
  );
}

pw.Widget _buildTableCell(String text) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(8.0),
    child: pw.Text(text),
  );
}

pw.Widget _buildTotalRow(String label, String amount) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 4.0),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label),
        pw.Text(amount),
      ],
    ),
  );
}


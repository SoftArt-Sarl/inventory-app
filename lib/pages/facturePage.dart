// ignore_for_file: deprecated_member_use

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class InvoicePage extends StatelessWidget {
  const InvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Left Column
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Factures',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                printInvoice();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              child: const Text('+ New'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[200],
                                // : Colors.grey[700],
                              ),
                              child: const Text('▼'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: List.generate(8, (index) {
                            return InvoiceItem(
                              // clientName: 'Client $index',
                              invoiceNumber: 'INV-00${124 + index}',
                              date: '08/06/2020',
                              amount: '\$${(index + 1) * 200}',
                              status: index % 2 == 0 ? 'SENT' : 'PENDING',
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Right Column
            const Expanded(
              flex: 2,
              child: InvoicePagee(),
            ),
          ],
        ),
      ),
    );
  }
}

class InvoiceItem extends StatelessWidget {
  // final String clientName;
  final String invoiceNumber;
  final String date;
  final String amount;
  final String status;

  const InvoiceItem({super.key, 
    // required this.clientName,
    required this.invoiceNumber,
    required this.date,
    required this.amount,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(value: false, onChanged: (value) {}),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(invoiceNumber, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('$date', style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: const TextStyle(color: Colors.blue)),
              Text(status, style: TextStyle(color: status == 'PENDING' ? Colors.red : Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}


class InvoicePagee extends StatelessWidget {
  const InvoicePagee({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 600), // max-w-2xl
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.network(
                      'https://storage.googleapis.com/a1aa/image/QEEofiUwIntu6h1MQ_yPjv4QRxzyckaQIFptEznf8YA.jpg',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'FACTURE',
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        Text('Facture No. 12345', style: TextStyle(fontSize: 12)),
                        Text('26 Juillet 2025', style: TextStyle(fontSize: 12)),
                        Text('14:30', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Table(
                  border: const TableBorder(
                    horizontalInside: BorderSide(color: Colors.grey),
                    verticalInside: BorderSide(color: Colors.grey),
                  ),
                  children: [
                    const TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Article', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Quantité', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Prix Unitaire', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    _buildTableRow('Nom de l\'article ici', '1', '215€', '215€'),
                    _buildTableRow('Nom de l\'article ici', '2', '120€', '240€'),
                    _buildTableRow('Nom de l\'article ici', '1', '130€', '130€'),
                  ],
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildTotalRow('Sous-total', '585€'),
                      _buildTotalRow('Taxe (0%)', '0€'),
                      const Text(
                        'Total à payer',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const Text('585€', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Center(child: Text('Merci pour votre achat !')),
                const SizedBox(height: 16),
                const Text('INFORMATIONS DE PAIEMENT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const Text('Méthode de paiement : À la caisse ou via MyNita'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nom de votre entreprise'),
                        Text('987 Rue Quelque Part, Toute Ville, Tout État 987655'),
                      ],
                    ),
                    Image.network(
                      'https://storage.googleapis.com/a1aa/image/x912kkwvucGKJN8W_fSjroBQ_rR1zNMKwgfsfJVA-_k.jpg',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
  }

  TableRow _buildTableRow(String article, String quantity, String unitPrice, String total) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(article),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(quantity),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(unitPrice),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(total),
        ),
      ],
    );
  }

  Widget _buildTotalRow(String label, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(amount),
        ],
      ),
    );
  }
}


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
                _buildTableRow('Nom de l\'article ici', '1', '215€', '215€'),
                _buildTableRow('Nom de l\'article ici', '2', '120€', '240€'),
                _buildTableRow('Nom de l\'article ici', '1', '130€', '130€'),
              ],
            ),
            pw.SizedBox(height: 16),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  _buildTotalRow('Sous-total', '585€'),
                  _buildTotalRow('Taxe (0%)', '0€'),
                  pw.Text('Total à payer',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 20)),
                  pw.Text('585€',
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


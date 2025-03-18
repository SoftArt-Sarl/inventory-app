// ignore_for_file: deprecated_member_use

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models.dart/invoiceModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/controller/invoiceController.dart';
import 'package:flutter_application_1/models.dart/invoiceModel.dart';

class InvoicePage extends StatelessWidget {
  const InvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final InvoiceController invoiceController = Get.put(InvoiceController());
    final Rx<Invoice?> selectedInvoice = Rx<Invoice?>(null);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Colonne gauche - Liste des factures
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre et boutons d'action
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
                                // Ajout d'une nouvelle facture (si nécessaire)
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                              child: const Text('+ New'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                invoiceController.refreshInvoices();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              child: const Text('⟳'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Liste des factures avec Obx
                    Expanded(
                      child: Obx(() {
                        if (invoiceController.isLoading.value) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (invoiceController.invoicesList.isEmpty) {
                          return const Center(child: Text("Aucune facture disponible"));
                        }

                        return ListView.builder(
                          itemCount: invoiceController.invoicesList.length,
                          itemBuilder: (context, index) {
                            final invoice = invoiceController.invoicesList[index];
                            return GestureDetector(
                              onTap: () {
                                selectedInvoice.value = invoice;
                              },
                              child: InvoiceItem(
                                invoiceNumber: invoice.seller.name,
                                date: invoice.createdAt.toString().split(' ')[0], // Format date
                                amount: '${invoice.finalAmount} FCFA',
                                 // Pas de statut dans Invoice, à adapter
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),

            // Colonne droite - Détails de la facture sélectionnée
            Expanded(
              flex: 2,
              child: Obx(() {
                if (selectedInvoice.value == null) {
                  return const Center(
                    child: Text(
                      "Sélectionnez une facture pour voir les détails",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  );
                }
                return InvoicePagee(invoice: selectedInvoice.value!);
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget pour afficher chaque facture dans la liste
class InvoiceItem extends StatelessWidget {
  // final String clientName;
  final String invoiceNumber;
  final String date;
  final String amount;

  const InvoiceItem({super.key, 
    // required this.clientName,
    required this.invoiceNumber,
    required this.date,
    required this.amount,

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
                  Text(date, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: const TextStyle(color: Colors.red)),
            ],
          ),
        ],
      ),
    );
  }
}




class InvoicePagee extends StatelessWidget {
  final Invoice invoice;
  final GlobalKey globalKey = GlobalKey();

  InvoicePagee({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          RepaintBoundary(
              key: globalKey,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 600),
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
                        // En-tête facture
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'assets/logo.jpg',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('FACTURE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Text(_formatDate(invoice.createdAt), style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
          
                        const SizedBox(height: 16),
          
                        // Infos vendeur & client
                        Text("Vendeur : ${invoice.seller.name}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text("Client : ${invoice.sale.custumerName}"),
                        Text("Adresse : ${invoice.sale.custumerAddress}"),
          
                        const SizedBox(height: 16),
          
                        // Tableau des articles
                        Table(
                          border: TableBorder.all(color: Colors.grey),
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
                            for (var item in invoice.sale.items)
                              _buildTableRow(item.item.name, item.quantity, item.item.unitPrice,item.quantity*item.item.unitPrice ),
                          ],
                        ),
          
                        const SizedBox(height: 16),
          
                        // Totaux
                        Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildTotalRow('Sous-total', invoice.totalAmount),
                              _buildTotalRow('Remise', invoice.discount),
                              _buildTotalRow('Taxe', invoice.taxAmount),
                              const Text('Total à payer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                              Text(invoice.finalAmount.toStringAsFixed(0), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                            ],
                          ),
                        ),
          
                        const SizedBox(height: 16),
          
                        const Center(child: Text('Merci pour votre achat !')),
          
                        const SizedBox(height: 16),
          
                        // Infos paiement
                        const Text('INFORMATIONS DE PAIEMENT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const Text('Méthode de paiement : À la caisse ou via MyNita'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String article, int quantity, double unitPrice, double total) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(article),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(quantity.toString()),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(unitPrice.toStringAsFixed(0)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(total.toStringAsFixed(0)),
        ),
      ],
    );
  }

  Widget _buildTotalRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text('${amount.toStringAsFixed(0)} FCFA'),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute}";
  }

  Future<Uint8List> _captureWidgetToImage() async {
    RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> _captureAndPrintPDF() async {
    Uint8List imageBytes = await _captureWidgetToImage();
    final pdf = pw.Document();
    final image = pw.MemoryImage(imageBytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(image, fit: pw.BoxFit.contain),
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}


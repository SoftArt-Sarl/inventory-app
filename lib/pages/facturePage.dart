import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/controller/appController.dart';
import 'package:flutter_application_1/models.dart/deliveryModel.dart';
import 'package:flutter_application_1/widget/popupButton.dart';
import 'package:flutter_application_1/widget/searchbarUserwidget.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/controller/invoiceController.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../models.dart/invoiceModel.dart';

class InvoicePage extends StatelessWidget {
  const InvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final InvoiceController invoiceController = Get.put(InvoiceController());
    final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
    final Rx<DateTimeRange?> selectedRange = Rx<DateTimeRange?>(null);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SearchBarWithFilter(
              calendarwidget: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Obx(() {
                      return DateFilterWidget(
                        selectedDate: selectedDate.value,
                        onSelectDate: () => _selectDate(context, selectedDate),
                        onClearDate: () => selectedDate.value = null,
                      );
                    }),
                    const SizedBox(width: 10),
                    Obx(() {
                      return DateRangeFilterWidget(
                        selectedRange: selectedRange.value,
                        onSelectRange: () => pickDateRange(context, selectedRange),
                        onClearRange: () => selectedRange.value = null,
                      );
                    }),
                  ],
                ),
              ),
              originalList: invoiceController.invoicesList,
              filteredList: invoiceController.invoicesfilteredList,
              filterFunction: (invoice, query) => invoice.sale.custumerName
                  .toLowerCase()
                  .contains(query.toLowerCase()),
            ),
            Expanded(
              child: InvoiceListView(
                invoiceController: invoiceController,
                selectedDate: selectedDate,
                selectedRange: selectedRange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, Rx<DateTime?> selectedDate) async {
  DateTime? picked = await showDatePicker(
    context: context,
    initialDate: selectedDate.value ?? DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime.now(),
    builder: (context, child) {
      return Theme(
        data: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: Colors.orange, // Couleur du header et des boutons
            onPrimary: Colors.white, // Couleur du texte sur le header
            onSurface: Colors.black, // Couleur du texte général
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.orange, // Couleur des boutons "OK" et "Annuler"
            ),
          ),
        ),
        child: child!,
      );
    },
  );

  if (picked != null && picked != selectedDate.value) {
    selectedDate.value = picked;
    invoiceController.selectedInvoice.value;
  }
}

Future<void> pickDateRange(BuildContext context, Rx<DateTimeRange?> selectedRange) async {
  if (selectedRange.value != null) return;

  final DateTimeRange? picked = await showDateRangePicker(
    context: context,
    firstDate: DateTime(2000),
    lastDate: DateTime.now(),
    builder: (context, child) {
      return Theme(
        data: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: Colors.orange, // Couleur du header et des boutons
            onPrimary: Colors.white, // Couleur du texte sur le header
            onSurface: Colors.black, // Couleur du texte général
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.orange, // Couleur des boutons "OK" et "Annuler"
            ),
          ),
        ),
        child: Dialog(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: child,
          ),
        ),
      );
    },
  );

  if (picked != null) {
    selectedRange.value = DateTimeRange(
      start: picked.start,
      end: picked.end.add(const Duration(hours: 23, minutes: 59, seconds: 59)), // 🔥 Correction ici
    );
    invoiceController.selectedInvoice.value == null;
  }
}



}

// Le reste de votre code pour InvoiceListView, DateFilterWidget, DateRangeFilterWidget, et InvoiceItem reste inchangé.

class InvoiceListView extends StatelessWidget {
  final InvoiceController invoiceController;
  final Rx<DateTime?> selectedDate;
  final Rx<DateTimeRange?> selectedRange;

  const InvoiceListView({
    Key? key,
    required this.invoiceController,
    required this.selectedDate,
    required this.selectedRange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 5),
      elevation: 3,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Obx(() {
                if (invoiceController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (invoiceController.invoicesfilteredList.isEmpty) {
                  return const Center(child: Text("No invoice available"));
                }

                List<Invoice> filteredInvoices = invoiceController.invoicesfilteredList;

                // Filtrer les factures par date sélectionnée
                if (selectedDate.value != null) {
                  filteredInvoices = filteredInvoices.where((invoice) {
                    return invoice.createdAt.year == selectedDate.value!.year &&
                           invoice.createdAt.month == selectedDate.value!.month &&
                           invoice.createdAt.day == selectedDate.value!.day;
                  }).toList();
                }

                // Filtrer les factures par plage de dates sélectionnée
                if (selectedRange.value != null) {
                  filteredInvoices = filteredInvoices.where((invoice) {
                    return invoice.createdAt.isAfter(selectedRange.value!.start) &&
                           invoice.createdAt.isBefore(selectedRange.value!.end);
                  }).toList();
                }

                if (filteredInvoices.isEmpty) {
                  return const Center(child: Text("No invoice for this period"));
                }

                // Trier les factures du plus récent au plus ancien
                filteredInvoices.sort((a, b) => b.createdAt.compareTo(a.createdAt));

                // Regrouper les factures par date
                final groupedInvoices = <String, List<Invoice>>{};
                for (var invoice in filteredInvoices) {
                  final dateKey = "${invoice.createdAt.day}/${invoice.createdAt.month}/${invoice.createdAt.year}";
                  groupedInvoices.putIfAbsent(dateKey, () => []).add(invoice);
                }

                return ListView(
                  padding: const EdgeInsets.all(8),
                  children: groupedInvoices.entries.map((entry) {
                    return StickyHeader(
                      header: Container(
                        color: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                        child: Text(
                          entry.key,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                      content: Column(
                        children: entry.value.map((invoice) {
                          return Obx(() {
                            bool isSelected = invoiceController.selectedInvoice.value == invoice;

                            return InkWell(
                              onTap: () {
                                invoiceController.selectedInvoice.value = invoice;
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: InvoiceItem(
                                  sellerName: invoice.seller.name,
                                  customerName: invoice.sale.custumerName,
                                  date: "${invoice.createdAt.day}/${invoice.createdAt.month}/${invoice.createdAt.year}",
                                  amount: '${invoice.finalAmount.toStringAsFixed(0)} FCFA',
                                  productCount: invoice.sale.items.fold(0, (total, e) => total + e.quantity),
                                  isSelected: isSelected,
                                ),
                              ),
                            );
                          });
                        }).toList(),
                      ),
                    );
                  }).toList(),
                );
              }),
            ),
          ),
          const VerticalDivider(),
          Expanded(
            flex: 2,
            child: Obx(() {
              if (invoiceController.selectedInvoice.value == null) {
                return const Center(
                  child: Text(
                    "Select an invoice to get more details",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                );
              }
              return InvoicePagee(
                isDeliveryPage: false,
                invoice: invoiceController.selectedInvoice.value!,
              );
            }),
          ),
        ],
      ),
    );
  }
}

class DateFilterWidget extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onSelectDate;
  final VoidCallback onClearDate;

  const DateFilterWidget({
    Key? key,
    required this.selectedDate,
    required this.onSelectDate,
    required this.onClearDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return selectedDate == null
        ? InkWell(
            onTap: onSelectDate,
            child: const Card(
              elevation: 4,
              margin: EdgeInsets.zero,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.orange),
                    SizedBox(width: 5),
                    Text('Select date'),
                  ],
                ),
              ),
            ),
          )
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: onClearDate,
                  child: const Icon(Icons.close, size: 18, color: Colors.red),
                ),
              ],
            ),
          );
  }
}

class DateRangeFilterWidget extends StatelessWidget {
  final DateTimeRange? selectedRange;
  final VoidCallback onSelectRange;
  final VoidCallback onClearRange;

  const DateRangeFilterWidget({
    Key? key,
    required this.selectedRange,
    required this.onSelectRange,
    required this.onClearRange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return selectedRange == null
        ? InkWell(
            onTap: onSelectRange,
            child: const Card(
              elevation: 4,
              margin: EdgeInsets.zero,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.orange),
                    SizedBox(width: 5),
                    Text('Select date range'),
                  ],
                ),
              ),
            ),
          )
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${selectedRange!.start.day}/${selectedRange!.start.month}/${selectedRange!.start.year} - ${selectedRange!.end.day}/${selectedRange!.end.month}/${selectedRange!.end.year}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: onClearRange,
                  child: const Icon(Icons.close, size: 18, color: Colors.red),
                ),
              ],
            ),
          );
  }
}

// Widget pour afficher chaque facture dans la liste
class InvoiceItem extends StatelessWidget {
  final String date;
  final String customerName;
  final int productCount;
  final String amount;
  final String sellerName;
  final bool isSelected;

  const InvoiceItem({
    super.key,
    required this.date,
    required this.customerName,
    required this.productCount,
    required this.amount,
    required this.sellerName,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.person_outline, size: 18, color: Colors.blue),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          customerName,
                          style: const TextStyle(overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(date),
                if (isSelected)
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      Checkbox(value: isSelected, onChanged: (_) {}),
                    ],
                  )
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.shopping_cart_outlined, size: 18, color: Colors.orange),
                const SizedBox(width: 6),
                Text('Items: $productCount'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.store_outlined, size: 18, color: Colors.green),
                const SizedBox(width: 6),
                Text('Sold by: $sellerName'),
                const Spacer(),
                Text(amount, style: const TextStyle(color: Colors.blue, fontSize: 15)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Le reste de votre code pour InvoicePagee et DeliveryUploadwidget reste inchangé

class InvoicePagee extends StatelessWidget {
  final Invoice invoice;
  final bool isDeliveryPage;

  const InvoicePagee({super.key, required this.invoice, required this.isDeliveryPage});

  @override
  Widget build(BuildContext context) {
    final buttonKey = GlobalKey();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10, top: 5, left: 10),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: _generateAndPrintPDF,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Print',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20,),
              if(userinfo.authmodel.value.user!.role == "SELLER")
              OutlinedButton(
                key: buttonKey,
                style: OutlinedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () {
                  
                  PopupHelper.showPopup(
                    context: context,
                    buttonKey: buttonKey,
                    width: 300,
                    popupContent: DeliveryUploadwidget(context: context,),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text(
                      'Deliver',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ],
                ),
              ),
              Spacer(),
              // const Spacer(),
              InkWell(
                onTap: () {
                  isDeliveryPage? deliveryController.selectedInvoice.value=null:
                  invoiceController.selectedInvoice.value = null;
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.orange,
                    size: 30,
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(5),
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/logo.jpg', width: 50, height: 50),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('INVOICE',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(_formatDate(invoice.createdAt),
                              style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text("Seller : ${invoice.seller.name}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("Custumer name : ${invoice.sale.custumerName}"),
                  Text("Address : ${invoice.sale.custumerAddress}"),
                  const SizedBox(height: 16),
                  Table(
                    border: TableBorder.all(color: Colors.grey),
                    children: [
                      const TableRow(
                        children: [
                          Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Product',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Quantity',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Unit price',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Total',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ],
                      ),
                      for (var item in invoice.sale.items)
                        buildTableRow(
                            item.item.name,
                            item.quantity,
                            item.item.unitPrice,
                            item.quantity * item.item.unitPrice),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        buildTotalRow('Total amount', invoice.totalAmount),
                        buildTotalRow('Discount', invoice.discount),
                        buildTotalRow('Taxe', invoice.taxAmount),
                        const Text('Final amount',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        Text('${invoice.finalAmount.toStringAsFixed(0)} FCFA',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(child: Text('Thank your for your purchase !')),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  TableRow buildTableRow(
      String article, int quantity, double unitPrice, double total) {
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

  Widget buildTotalRow(String label, double amount) {
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

  Future<void> _generateAndPrintPDF() async {
    final pdf = pw.Document();

    // Charger le logo depuis les assets
    final ByteData data = await rootBundle.load('assets/logo.jpg');
    final Uint8List logoBytes = data.buffer.asUint8List();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Ajouter le logo en haut à gauche
                // Logo
                pw.Row(children: [
                  pw.Image(pw.MemoryImage(logoBytes), width: 50, height: 50),
                  pw.Spacer(),
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.Text('Invoice',
                            style: pw.TextStyle(
                                fontSize: 16, fontWeight: pw.FontWeight.bold)),
                        pw.Text(_formatDate(invoice.createdAt),
                            style: const pw.TextStyle(fontSize: 12)),
                      ])
                ]),

                pw.SizedBox(height: 16),
                pw.Text("Seller : ${invoice.seller.name}",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("Client name : ${invoice.sale.custumerName}"),
                pw.Text("Address : ${invoice.sale.custumerAddress}"),
                pw.SizedBox(height: 16),
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey),
                  children: [
                    pw.TableRow(
                      children: [
                        _buildTableHeader("Product"),
                        _buildTableHeader("Quantity"),
                        _buildTableHeader("Unit Price"),
                        _buildTableHeader("Total"),
                      ],
                    ),
                    for (var item in invoice.sale.items)
                      _buildTableRow(
                          item.item.name,
                          item.quantity,
                          item.item.unitPrice,
                          item.quantity * item.item.unitPrice),
                  ],
                ),
                pw.SizedBox(height: 16),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      _buildTotalRow('Total amount', invoice.totalAmount),
                      _buildTotalRow('Discount', invoice.discount),
                      _buildTotalRow('Taxe', invoice.taxAmount),
                      pw.Text('Final amount',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 20)),
                      pw.Text('${invoice.finalAmount.toStringAsFixed(0)} FCFA',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 20)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Center(child: pw.Text('Thank your for your purchase !')),
              ],
            ),
          );
        },
      ),
    );

    // Envoi du PDF à l'imprimante
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  pw.Widget _buildTableHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8.0),
      child: pw.Text(text, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
    );
  }

  pw.TableRow _buildTableRow(
      String name, int quantity, double unitPrice, double total) {
    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(8.0), child: pw.Text(name)),
        pw.Padding(
            padding: const pw.EdgeInsets.all(8.0),
            child: pw.Text(quantity.toString())),
        pw.Padding(
            padding: const pw.EdgeInsets.all(8.0),
            child: pw.Text(unitPrice.toStringAsFixed(0))),
        pw.Padding(
            padding: const pw.EdgeInsets.all(8.0),
            child: pw.Text(total.toStringAsFixed(0))),
      ],
    );
  }

  pw.Widget _buildTotalRow(String label, double value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 4, bottom: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label),
          pw.Text('${value.toStringAsFixed(0)} FCFA',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute}";
  }
}

class DeliveryUploadwidget extends StatelessWidget {
  BuildContext context;
  final TextEditingController deliveryManController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Delivery? delivery; // Paramètre optionnel pour l'édition d'une livraison

  // Constructeur prenant la livraison (si existante)
  DeliveryUploadwidget({this.delivery,required this.context});

  @override
  Widget build(BuildContext context) {
    // Si la livraison existe, on préremplit les champs
    if (delivery != null) {
      deliveryManController.text = delivery!.deliveryMan;
      locationController.text = delivery!.location;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Deliveries',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            // Utilisation de _buildTextField pour Delivery Man
            _buildTextField(
              label: "Delivery Man",
              icon: Icons.person,
              hintext: "Enter the delivery man's name",
              controller: deliveryManController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the delivery man\'s name';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),

            // Utilisation de _buildTextField pour Location
            _buildTextField(
              label: "Location",
              icon: Icons.location_on,
              hintext: "Enter the delivery location",
              controller: locationController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the location';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Bouton de validation
            Obx(
              () {
                // Affiche un indicateur de chargement si les données sont en cours de récupération
                if (deliveryController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &&
                        invoiceController.selectedInvoice.value != null) {
                      final deliveryMan = deliveryManController.text;
                      final location = locationController.text;

                      // Si une livraison est fournie, on met à jour la livraison, sinon on en crée une nouvelle
                      if (delivery == null) {
                        // Création d'une nouvelle livraison
                      await  deliveryController.postDelivery(context,
                          invoiceController.selectedInvoice.value!.saleId,
                          deliveryMan,
                          location,
                        );
                      } else {
                        // Mise à jour de la livraison existante
                       await deliveryController.updateDeliveryInfo(
                        context,
                          delivery!.id, // Utilisation de l'id de la livraison
                          deliveryMan,
                          location,
                        );
                      }
                    } else {
                      Get.snackbar('Error', 'Enter valid inputs');
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Confirm',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required String hintext,
    required TextEditingController controller,
    bool onlyNumbers = false,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: TextFormField(
            onChanged: onChanged,
            controller: controller,
            validator: validator,
            keyboardType:
                onlyNumbers ? TextInputType.number : TextInputType.text,
            inputFormatters:
                onlyNumbers ? [FilteringTextInputFormatter.digitsOnly] : [],
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              hintText: hintext,
              fillColor: Colors.grey[200],
              prefixIcon: Icon(icon, color: Colors.orange),
              border: InputBorder.none,
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


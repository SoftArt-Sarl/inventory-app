import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/facturePage.dart';
import 'package:flutter_application_1/widget/searchbarUserwidget.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/controller/appController.dart';
import 'package:flutter_application_1/controller/invoiceController.dart';
import 'package:flutter_application_1/models.dart/deliveryModel.dart';
import 'package:flutter_application_1/widget/popupButton.dart';

class DeliveryPage extends StatelessWidget {
  final InvoiceController invoiceController = Get.put(InvoiceController());

  @override
  Widget build(BuildContext context) {
    final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
    final Rx<DateTimeRange?> selectedRange = Rx<DateTimeRange?>(null);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SearchBarWithFilter(
              calendarwidget: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                  onPressed: () async {
                    await deliveryController.getDeliveries();
                  },
                  icon: const Icon(Icons.refresh_outlined,color: Colors.orange,),
                ),const SizedBox(width: 10,),
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
              originalList: deliveryController.deliveries,
              filteredList: deliveryController.deliveriefilter,
              filterFunction: (delivery, query) => delivery.sale.custumerName
                  .toLowerCase()
                  .contains(query.toLowerCase()),
            ),
            const SizedBox(height: 16,),
            Expanded(
              child: DeliveryListView(
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
              primary: Colors.orange,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.orange,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
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
              primary: Colors.orange,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.orange,
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
      selectedRange.value = picked;
    }
  }
}

class DeliveryListView extends StatelessWidget {
  final InvoiceController invoiceController;
  final Rx<DateTime?> selectedDate;
  final Rx<DateTimeRange?> selectedRange;

  const DeliveryListView({
    Key? key,
    required this.invoiceController,
    required this.selectedDate,
    required this.selectedRange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Obx(() {
                  if (deliveryController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (deliveryController.deliveries.isEmpty) {
                    return const Center(child: Text('Aucune livraison disponible'));
                  }

                  List<Delivery> filteredDeliveries = _filterDeliveries(deliveryController.deliveries);

                  return SingleChildScrollView(
                    child: Column(
                      children: filteredDeliveries.map((delivery) {
                        return DeliveryCard(delivery: delivery);
                      }).toList(),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        const VerticalDivider(width: 0),
        Obx(() {
          final selectedInvoice = deliveryController.selectedInvoice.value;
          if (selectedInvoice != null) {
            return Expanded(
              flex: 3,
              child: Card(
                shape: const RoundedRectangleBorder(),
                margin: const EdgeInsets.only(top: 0, right: 5, left: 5, bottom: 5),
                color: Colors.white,
                child: InvoicePagee(
                  isDeliveryPage: true,
                  invoice: selectedInvoice,
                ),
              ),
            );
          } else {
            return const SizedBox.shrink(); // Affiche rien si null
          }
        }),
      ],
    );
  }

  List<Delivery> _filterDeliveries(List<Delivery> deliveries) {
    // Filtrage par date unique
    if (selectedDate.value != null) {
      deliveries = deliveries.where((delivery) {
        return delivery.createdAt.year == selectedDate.value!.year &&
               delivery.createdAt.month == selectedDate.value!.month &&
               delivery.createdAt.day == selectedDate.value!.day;
      }).toList();
    }

    // Filtrage par plage de dates
    if (selectedRange.value != null) {
      deliveries = deliveries.where((delivery) {
        return delivery.createdAt.isAfter(selectedRange.value!.start) &&
               delivery.createdAt.isBefore(selectedRange.value!.end);
      }).toList();
    }

    return deliveries;
  }

  Widget _buildHeader() {
    return Card(
      shape: RoundedRectangleBorder(),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      elevation: 2,
      child: Obx(() => Row(
        children: [
          _buildHeaderCell('Delivery Man', flex: 2), // Colonne la plus large
          if(deliveryController.selectedInvoice.value==null) _buildHeaderCell('Customer', flex: 2),
          _buildHeaderCell('Location', flex: deliveryController.selectedInvoice.value==null?1:2),
          _buildHeaderCell('Status', flex: 1),
          _buildHeaderCell('Invoices', flex: 1),
          if (userinfo.authmodel.value.user!.role == "SELLER" && deliveryController.selectedInvoice.value==null)
           _buildHeaderCell('Action', flex: 1),
        ],
      ),),
    );
  }

  Widget _buildHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class DeliveryCard extends StatelessWidget {
  final Delivery delivery;

  const DeliveryCard({
    Key? key,
    required this.delivery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(),
      margin: const EdgeInsets.only(bottom: 1, left: 5, right: 5),
      elevation: 2,
      child: Obx(() => Row(
        children: [
          _buildDataCell(delivery.deliveryMan, flex: 2), // Colonne la plus large
         if(deliveryController.selectedInvoice.value==null) _buildDataCell(delivery.sale.custumerName, flex: 2),
          _buildDataCell(delivery.location, flex: deliveryController.selectedInvoice.value==null?1:2),
          _buildStatusCell(delivery, context, flex: 1),
          _buildInvoiceCell(delivery.sale.invoice.id, flex: 1),
          if (userinfo.authmodel.value.user!.role == "SELLER" && deliveryController.selectedInvoice.value==null) 
            _buildActionCell(delivery, context, flex: 1), // Colonne Action
        ],
      ),),
    );
  }

  Widget _buildDataCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildInvoiceCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            deliveryController.selectedInvoice.value = invoiceController.invoicesList.firstWhere(
              (element) => element.id == text,
            );
          },
          child: const Icon(Icons.launch),
        ),
      ),
    );
  }

  Widget _buildStatusCell(Delivery delivery, BuildContext context, {int flex = 1}) {
    final buttonKey = GlobalKey();

    return Expanded(
      flex: flex,
      child: InkWell(
        key: buttonKey,
        onTap: () {
          if (userinfo.authmodel.value.user!.role == 'SELLER') {
            PopupHelper.showPopup(
              context: context,
              buttonKey: buttonKey,
              width: 200,
              popupContent: statusWindow(delivery,context),
            );
          }
        },
        child: Obx(() {
          bool isLoading = deliveryController.isLoadingMap[delivery.id] ?? false;

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: _getStatusColor(delivery.status),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        _getStatusString(delivery.status),
                        style: TextStyle(color: _getTextColor(delivery.status)),
                        textAlign: TextAlign.center,
                      ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ... (le reste de votre code pour statusWindow, _getStatusColor, _getTextColor, _getStatusString)
  Widget statusWindow(Delivery delivery,BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: DeliveryStatus.values.map((status) {
          return ListTile(
            selectedColor: Colors.grey,
            title: Text(_getStatusString(status)),
            leading: Icon(Icons.circle, color: _getStatusColor(status)),
            onTap: () async {
              Get.back(); // Ferme le menu
              await deliveryController.updateDeliveryStatus(context,delivery.id, status);
            },
          );
        }).toList(),
      ),
    );
  }

  Color _getStatusColor(DeliveryStatus status) {
    switch (status) {
      case DeliveryStatus.PENDING:
        return Colors.yellow;
      case DeliveryStatus.IN_PROGRESS:
        return Colors.blue;
      case DeliveryStatus.DELIVERED:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getTextColor(DeliveryStatus status) {
    switch (status) {
      case DeliveryStatus.PENDING:
        return Colors.black;
      case DeliveryStatus.IN_PROGRESS:
      case DeliveryStatus.DELIVERED:
        return Colors.white;
      default:
        return Colors.black;
    }
  }

  String _getStatusString(DeliveryStatus status) {
    switch (status) {
      case DeliveryStatus.PENDING:
        return 'Pending';
      case DeliveryStatus.IN_PROGRESS:
        return 'In Progress';
      case DeliveryStatus.DELIVERED:
        return 'Delivered';
      default:
        return 'Unknown';
    }
  }

  Widget _buildActionCell(Delivery delivery, BuildContext context,{int flex = 1}) {
    final buttonKey = GlobalKey();

    return Obx(() {
      bool isLoading = deliveryController.isLoadingMap1[delivery.id] ?? false;
      return Expanded(
        flex: flex,
        child: isLoading
            ? const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.orange),
                ),
              ])
            : InkWell(
                key: buttonKey,
                onTap: () {
                  PopupHelper.showPopup(
                    context: context,
                    buttonKey: buttonKey,
                    width: 300,
                    popupContent: DeliveryUploadwidget(context: context,delivery: delivery),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.orange)),
                  child: const Icon(Icons.edit_outlined, size: 18, color: Colors.orange),
                ),
              ),
      );
    });
  }
}
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
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                      icon: const Icon(
                        Icons.refresh_outlined,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 10),
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
                        onSelectRange: () =>
                            pickDateRange(context, selectedRange),
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
            const SizedBox(height: 5),
            if (!appTypeController.isDesktop.value)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                child: Row(
                  children: [
                    Obx(() {
                      return Expanded(
                        child: DateFilterWidget(
                          selectedDate: selectedDate.value,
                          onSelectDate: () =>
                              _selectDate(context, selectedDate),
                          onClearDate: () => selectedDate.value = null,
                        ),
                      );
                    }),
                    const SizedBox(width: 10),
                    Obx(() {
                      return Expanded(
                        child: DateRangeFilterWidget(
                          selectedRange: selectedRange.value,
                          onSelectRange: () =>
                              pickDateRange(context, selectedRange),
                          onClearRange: () => selectedRange.value = null,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            const SizedBox(height: 8),
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

  Future<void> _selectDate(
      BuildContext context, Rx<DateTime?> selectedDate) async {
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

  Future<void> pickDateRange(
      BuildContext context, Rx<DateTimeRange?> selectedRange) async {
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
  int? itemlenght;
  DeliveryListView(
      {Key? key,
      required this.invoiceController,
      required this.selectedDate,
      required this.selectedRange,
      this.itemlenght})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    appTypeController.checkScreenType(context);
    return Obx(() {
      if (deliveryController.isLoading.value) {
        return  Center(child:itemlenght!=null?const Text(''): const CircularProgressIndicator());
      }

      if (deliveryController.deliveries.isEmpty) {
        return  Center(child: Text( itemlenght!=null?'':'Aucune livraison disponible'));
      }

      List<Delivery> filteredDeliveries =
          _filterDeliveries(deliveryController.deliveries);

      if (!appTypeController.isDesktop.value) {
        // Version mobile
        return SingleChildScrollView(
          child: Column(
            children: itemlenght != null
                ? filteredDeliveries
                    .where(
                      (element) => element.status != DeliveryStatus.DELIVERED,
                    )
                    .toList()
                    .map((delivery) {
                    return DeliveryCardMobile(isFromDashbord: itemlenght != null,delivery: delivery);
                  }).toList()
                : filteredDeliveries.map((delivery) {
                    return DeliveryCardMobile(isFromDashbord: itemlenght != null,delivery: delivery);
                  }).toList(),
          ),
        );
      } else {
        // Version desktop
        return itemlenght != null
            ? Column(
                children: [
                  _buildHeader(
                    itemlenght: filteredDeliveries
                        .where(
                          (element) =>
                              element.status != DeliveryStatus.DELIVERED,
                        )
                        .toList()
                        .length,
                  ),
                  const Divider(
                    thickness: 0,
                  ),
                  SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      children: filteredDeliveries
                          .where(
                            (element) =>
                                element.status != DeliveryStatus.DELIVERED,
                          )
                          .toList()
                          .map((delivery) {
                        return DeliveryCard(
                          delivery: delivery,
                          itemlenght: filteredDeliveries
                              .where(
                                (element) =>
                                    element.status != DeliveryStatus.DELIVERED,
                              )
                              .toList()
                              .length,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        _buildHeader(),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: filteredDeliveries.map((delivery) {
                                return DeliveryCard(delivery: delivery);
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(width: 0),
                  Obx(() {
                    final selectedInvoice =
                        deliveryController.selectedInvoice.value;
                    if (selectedInvoice != null) {
                      return Expanded(
                        flex: 3,
                        child: Card(
                          shape: const RoundedRectangleBorder(),
                          margin: const EdgeInsets.only(
                              top: 0, right: 5, left: 5, bottom: 5),
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
    });
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

  Widget _buildHeader({int? itemlenght}) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular((5)))),
      margin: const EdgeInsets.only(left: 5, right: 5, top: 1, bottom: 2),
      elevation: 0,
      child: Obx(
        () => Row(
          children: [
            _buildHeaderCell('Delivery Man', flex: 1), // Colonne la plus large
            _buildHeaderCell('Date', flex: 1),
            if (deliveryController.selectedInvoice.value == null)
              _buildHeaderCell('Customer', flex: 2),
            _buildHeaderCell('Location',
                flex: deliveryController.selectedInvoice.value == null ? 1 : 2),
            _buildHeaderCell('Status', flex: 1),
            if (itemlenght == null) _buildHeaderCell('Invoices', flex: 1),
            if (userinfo.authmodel.value.user!.role == "SELLER" &&
                deliveryController.selectedInvoice.value == null)
              if (itemlenght == null) _buildHeaderCell('Action', flex: 1),
          ],
        ),
      ),
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

class DeliveryCardMobile extends StatelessWidget {
  bool? isFromDashbord=false;
  final Delivery delivery;

   DeliveryCardMobile({
    super.key,
    required this.delivery,
    this.isFromDashbord=false
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      margin: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
      elevation: isFromDashbord!?0: 4,
      child: Container( 
        decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: Colors.orange))),
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Delivery Man: ${delivery.deliveryMan}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Customer: ${delivery.sale.custumerName}'),
            Text('Location: ${delivery.location}'),
            const SizedBox(height: 8), // Espacement
            SingleChildScrollView(scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatusCell(delivery, context),
                  const SizedBox(
                    width: 10,
                  ),
                  _buildInvoiceCell(delivery.sale.invoice.id, context),
                  _buildActionCell(delivery, context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCell(Delivery delivery, BuildContext context,
      {int flex = 1}) {
    final buttonKey = GlobalKey();

    return Obx(() {
      bool isLoading = deliveryController.isLoadingMap1[delivery.id] ?? false;
      return isLoading
          ? const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.orange),
              ),
            ])
          : InkWell(
              key: buttonKey,
              onTap: () {
                PopupHelper.showPopup(
                  context: context,
                  buttonKey: buttonKey,
                  width: 300,
                  popupContent: DeliveryUploadwidget(
                      context: context, delivery: delivery),
                );
              },
              child: Container(
                margin: EdgeInsets.only(left: 10),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    // shape: BoxShape.circle,
                    border: Border.all(color: Colors.orange)),
                child: const Text('Edit'),
              ),
            );
    });
  }

  Widget _buildStatusCell(Delivery delivery, BuildContext context) {
    final buttonKey = GlobalKey();

    return InkWell(
      key: buttonKey,
      onTap: () {
        if (userinfo.authmodel.value.user!.role == 'SELLER') {
          PopupHelper.showPopup(
            context: context,
            buttonKey: buttonKey,
            width: 200,
            popupContent: statusWindow(delivery, context),
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
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
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
    );
  }

  Widget _buildInvoiceCell(String text, BuildContext context) {
    return InkWell(
      onTap: () {
        deliveryController.selectedInvoice.value =
            invoiceController.invoicesList.firstWhere(
          (element) => element.id == text,
        );
        !appTypeController.isDesktop.value
            ? Get.bottomSheet(
                InvoicePagee(
                  isDeliveryPage: true,
                  invoice: deliveryController.selectedInvoice.value!,
                ),
                isScrollControlled: true)
            : null;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.orange),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Invoices',
          style: TextStyle(),
        ),
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

  Widget statusWindow(Delivery delivery, BuildContext context) {
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
              await deliveryController.updateDeliveryStatus(
                  context, delivery.id, status);
            },
          );
        }).toList(),
      ),
    );
  }
}

class DeliveryCard extends StatelessWidget {
  final Delivery delivery;
  int? itemlenght;
  DeliveryCard({
    super.key,
    required this.delivery,
    this.itemlenght,
  });

  @override
  Widget build(BuildContext context) {
    String _formatDate(DateTime date) {
      return "${date.day}/${date.month}/${date.year}";
    }

    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      margin: const EdgeInsets.only(bottom: 2, left: 5, right: 5),
      elevation: 0,
      child: Obx(
        () => Row(
          children: [
            _buildDataCell(delivery.deliveryMan, flex: 1),
            _buildDataCell(_formatDate(delivery.createdAt),
                flex: 1), // Colonne la plus large
            if (deliveryController.selectedInvoice.value == null)
              _buildDataCell(delivery.sale.custumerName, flex: 2),
            _buildDataCell(delivery.location,
                flex: deliveryController.selectedInvoice.value == null ? 1 : 2),
            _buildStatusCell(delivery, context, flex: 1),
            if (itemlenght == null)
              _buildInvoiceCell(delivery.sale.invoice.id, flex: 1),
            if (userinfo.authmodel.value.user!.role == "SELLER" &&
                deliveryController.selectedInvoice.value == null)
              if (itemlenght == null)
                _buildActionCell(delivery, context, flex: 1), // Colonne Action
          ],
        ),
      ),
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
            deliveryController.selectedInvoice.value =
                invoiceController.invoicesList.firstWhere(
              (element) => element.id == text,
            );
          },
          child: const Icon(Icons.launch),
        ),
      ),
    );
  }

  Widget _buildStatusCell(Delivery delivery, BuildContext context,
      {int flex = 1}) {
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
              popupContent: statusWindow(delivery, context),
            );
          }
        },
        child: Obx(() {
          bool isLoading =
              deliveryController.isLoadingMap[delivery.id] ?? false;

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
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
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

  Widget statusWindow(Delivery delivery, BuildContext context) {
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
              await deliveryController.updateDeliveryStatus(
                  context, delivery.id, status);
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

  Widget _buildActionCell(Delivery delivery, BuildContext context,
      {int flex = 1}) {
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
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.orange),
                ),
              ])
            : InkWell(
                key: buttonKey,
                onTap: () {
                  PopupHelper.showPopup(
                    context: context,
                    buttonKey: buttonKey,
                    width: 300,
                    popupContent: DeliveryUploadwidget(
                        context: context, delivery: delivery),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.orange)),
                  child: const Icon(Icons.edit_outlined,
                      size: 18, color: Colors.orange),
                ),
              ),
      );
    });
  }
}

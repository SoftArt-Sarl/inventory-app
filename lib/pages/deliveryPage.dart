import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/userInfo.dart';
import 'package:flutter_application_1/pages/facturePage.dart';
import 'package:flutter_application_1/widget/popupButton.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/controller/appController.dart';
import 'package:flutter_application_1/models.dart/deliveryModel.dart';

class DeliveryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                const Text(
                  'Deliveries',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () async {
                    await deliveryController.getDeliveries();
                  },
                  icon: const Icon(Icons.refresh_outlined),
                ),
              ],
            ),
          ),
          // En-tête de tableau
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Obx(() => Card(
                            shape: RoundedRectangleBorder(),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 1),
                            elevation: 2,
                            child: Row(
                              children: [
                                _buildHeaderCell('Delivery Man'),
                                if (deliveryController.selectedInvoice.value ==
                                    null)
                                  _buildHeaderCell('Customer'),
                                _buildHeaderCell('Location'),
                                SizedBox(
                                    width: 120,
                                    child: _buildHeaderCell('Status')),
                                _buildHeaderCell('Invoices'), 
                                if(userinfo.authmodel.value.user!.role == "SELLER")
                                SizedBox(
                                    width: 80,
                                    child: _buildHeaderCell(
                                        'Action')), // Nouvelle colonne Action
                              ],
                            ),
                          )),
                      Expanded(
                        child: Obx(() {
                          if (deliveryController.isLoading.value) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (deliveryController.deliveries.isEmpty) {
                            return const Center(
                                child: Text('Aucune livraison disponible'));
                          }

                          return SingleChildScrollView(
                            child: Column(
                              children: deliveryController.deliveries.reversed
                                  .map((delivery) {
                                return Card(
                                  shape: const RoundedRectangleBorder(),
                                  margin: const EdgeInsets.only(
                                      bottom: 1, left: 10, right: 10),
                                  elevation: 2,
                                  child: Row(
                                    children: [
                                      _buildDataCell(delivery.deliveryMan),
                                      if (deliveryController
                                              .selectedInvoice.value ==
                                          null)
                                        _buildDataCell(
                                            delivery.sale.custumerName),
                                      _buildDataCell(delivery.location),
                                      _buildStatusCell(delivery, context),
                                      _builinvoiceCell(
                                          delivery.sale.invoice.id),
                                          if(userinfo.authmodel.value.user!.role == "SELLER")
                                      _buildActionCell(delivery,
                                          context), // Nouvelle cellule Action
                                    ],
                                  ),
                                );
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
                  final selectedInvoice =
                      deliveryController.selectedInvoice.value;
                  if (selectedInvoice != null) {
                    return Expanded(
                      flex: 2,
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
            ),
          ),
        ],
      ),
    );
  }

  // Formatage de la date
  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute}";
  }

  // Widget pour les en-têtes de colonne
  Widget _buildHeaderCell(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Widget pour les cellules de données
  Widget _buildDataCell(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _builinvoiceCell(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
            onTap: () {
              deliveryController.selectedInvoice.value =
                  invoiceController.invoicesList.firstWhere(
                (element) => element.id == text,
              );
            },
            child: const Icon(Icons.launch)),
      ),
    );
  }

  // Widget pour la cellule de statut avec menu déroulant
  Widget _buildStatusCell(Delivery delivery, BuildContext context) {
    final buttonKey = GlobalKey();

    return Container(
      width: 120,
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        key: buttonKey,
        onTap: () {
          if(userinfo.authmodel.value.user!.role == 'SELLER')
          PopupHelper.showPopup(
            context: context,
            buttonKey: buttonKey,
            width: 200,
            popupContent: statusWindow(delivery),
          );
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
                      )
              ],
            ),
          );
        }),
      ),
    );
  }

  // Fonction pour afficher le menu déroulant et mettre à jour le statut
  Widget statusWindow(Delivery delivery) {
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
                  delivery.id, status);
            },
          );
        }).toList(),
      ),
    );
  }

  // Obtenir la couleur de fond du statut
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

  // Obtenir la couleur du texte du statut
  Color _getTextColor(DeliveryStatus status) {
    switch (status) {
      case DeliveryStatus.PENDING:
        return Colors.black;
      case DeliveryStatus.IN_PROGRESS:
        return Colors.white;
      case DeliveryStatus.DELIVERED:
        return Colors.white;
      default:
        return Colors.black;
    }
  }

  // Obtenir le texte du statut
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

  // Nouvelle cellule Action avec bouton "more"
  Widget _buildActionCell(Delivery delivery, BuildContext context) {
    final buttonKey = GlobalKey();

    return Obx(() {
      bool isLoading = deliveryController.isLoadingMap1[delivery.id] ?? false;
      return Container(
        width: 80,
        padding: const EdgeInsets.all(8.0),
        child: isLoading
            ? const Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.orange),
                  ),
              ],
            )
            : InkWell(
                key: buttonKey,
                onTap: () {
                  PopupHelper.showPopup(
                    context: context,
                    buttonKey: buttonKey,
                    width: 300,
                    popupContent: DeliveryUploadwidget(
                      delivery: delivery,
                    ),
                  );
                },
                child: Container(padding: EdgeInsets.all(2),decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color: Colors.orange)),
                  child: const Icon(Icons.edit_outlined,
                    size: 18, color: Colors.orange),
                ),
              ),
      );
    });
  }
}

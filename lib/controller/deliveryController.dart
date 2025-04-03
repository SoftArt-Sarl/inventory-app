import 'package:flutter_application_1/controller/appController.dart';
import 'package:flutter_application_1/models.dart/deliveryModel.dart';
import 'package:flutter_application_1/models.dart/invoiceModel.dart';
import 'package:flutter_application_1/widget/popupButton.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
class DeliveryController extends GetxController {
  static DeliveryController instance = Get.find();
  var deliveries = <Delivery>[].obs;
  var deliveriefilter = <Delivery>[].obs;
  var isLoading = false.obs;
  var isLoading1 = false.obs;
  var isLoadingMap = <String, bool>{}.obs;
  var isLoadingMap1 = <String, bool>{}.obs; // Gestion du chargement par élément
final Rx<Invoice?> selectedInvoice = Rx<Invoice?>(null);
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://inventory-app-five-ebon.vercel.app'),
  ); // Instance de Dio

  Future<void> getDeliveries() async {
    isLoading.value = true;
    try {
      final response = await _dio.get('/delivery',
          options: Options(
            headers: {
              'Authorization':
                  'Bearer ${userinfo.authmodel.value.access_token}',
            },
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.data as List;
        deliveries.value = data.map((e) => Delivery.fromMap(e)).toList();
        deliveriefilter.assignAll(deliveries);
      } else {
        Get.snackbar('Erreur', 'Impossible de récupérer les livraisons',backgroundColor: Colors.red,colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de la requête',backgroundColor: Colors.red,colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> postDelivery(BuildContext context,String saleId, String deliveryMan, String location) async {
    isLoading.value = true;
    try {
      final response = await _dio.post(
        '/delivery/$saleId',
        data: {
          'deliveryMan': deliveryMan,
          'location': location,
        },
        options: Options(
          headers: {
            'Authorization':
                'Bearer ${userinfo.authmodel.value.access_token}',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Succès', 'Livraison ajoutée avec succès',backgroundColor: Colors.green,colorText: Colors.white);
      //  appTypeController.isDesktop.value?null: Get.back();
        await getDeliveries();
      } else {
        Get.snackbar('Erreur', 'Impossible d\'ajouter la livraison',backgroundColor: Colors.red,colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de la requête',backgroundColor: Colors.red,colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDeliveryStatus(BuildContext context,String deliveryId, DeliveryStatus status) async {
    isLoadingMap[deliveryId] = true; // Active le chargement pour cette livraison
    update(); // Met à jour l'UI

    try {
      final response = await _dio.patch(
        '/delivery/$deliveryId/status',
        data: {
          'status': status.toString().split('.').last,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${userinfo.authmodel.value.access_token}',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        PopupHelper.removePopup(context);
        Get.snackbar('Succès', 'Statut de la livraison mis à jour',backgroundColor: Colors.green,colorText: Colors.white);

        // Met à jour localement au lieu de tout recharger
        int index = deliveries.indexWhere((d) => d.id == deliveryId);
        if (index != -1) {
          deliveries[index] = deliveries[index].copyWith(status: status);
        }
      } else {
        Get.snackbar('Erreur', 'Impossible de mettre à jour le statut',backgroundColor: Colors.red,colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de la requête',backgroundColor: Colors.red,colorText: Colors.white);
    } finally {
      isLoadingMap[deliveryId] = false; // Désactive le chargement pour cet élément
      update(); // Met à jour l'UI
    }
  }
  Future<void> updateDeliveryInfo(BuildContext context,String deliveryId, String? deliveryMan, String? location) async {
  isLoadingMap1[deliveryId] = true; // Active le chargement pour cette livraison
  update(); // Met à jour l'UI

  // Crée un objet dynamique contenant les champs à modifier
  Map<String, dynamic> data = {};
  if (deliveryMan != null) data['deliveryMan'] = deliveryMan;
  if (location != null) data['location'] = location;

  try {
    final response = await _dio.patch(
      '/delivery/$deliveryId/info',
      data: data, // Envoie le corps avec les données à modifier
      options: Options(
        headers: {
          'Authorization': 'Bearer ${userinfo.authmodel.value.access_token}',
        },
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      PopupHelper.removePopup(context);
      Get.snackbar('Succès', 'Informations de livraison mises à jour avec succès', backgroundColor: Colors.green, colorText: Colors.white);

      // Met à jour localement les données de livraison
      int index = deliveries.indexWhere((d) => d.id == deliveryId);
      if (index != -1) {
        deliveries[index] = deliveries[index].copyWith2(
          deliveryMan: deliveryMan ?? deliveries[index].deliveryMan, // Si null, garde la valeur actuelle
          location: location ?? deliveries[index].location,         // Si null, garde la valeur actuelle
        );
      }
    } else {
      Get.snackbar('Erreur', 'Impossible de mettre à jour les informations', backgroundColor: Colors.red, colorText: Colors.white);
    }
  } catch (e) {
    Get.snackbar('Erreur', 'Erreur lors de la requête', backgroundColor: Colors.red, colorText: Colors.white);
  } finally {
    isLoadingMap1[deliveryId] = false; // Désactive le chargement pour cet élément
    update(); // Met à jour l'UI
  }
}

}

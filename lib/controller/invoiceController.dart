import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/models.dart/invoiceModel.dart';
import 'package:flutter_application_1/controller/appController.dart';

class InvoiceController extends GetxController {
  static InvoiceController instance = Get.find();

  final RxList<Invoice> invoicesList = <Invoice>[].obs;
  var isLoading = false.obs;

  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://inventory-app-five-ebon.vercel.app'),
  );

  // Fonction pour récupérer toutes les factures (invoices)
  Future<List<Invoice>> fetchInvoices() async {
    try {
      final response = await _dio.get('/sales/invoices',
          options: Options(
            headers: {
              'Authorization':
                  'Bearer ${userinfo.authmodel.value.access_token}',
            },
          ));
      List<dynamic> data = response.data;
// print(data.toString());
      return data.map((json) => Invoice.fromMap(json)).toList();
      
    } catch (e) {
      throw Exception('Erreur lors de la récupération des invoices: $e');
    }
  }

  // Fonction pour charger les invoices et mettre à jour la liste
  Future<void> fetchAndStoreInvoices() async {
    try {
      isLoading.value = true;
      final fetchedInvoices = await fetchInvoices();
      invoicesList.assignAll(fetchedInvoices);
      print(fetchedInvoices.length);
    } catch (e) {
      print('Erreur lors du chargement des invoices: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Rafraîchissement des invoices
  Future<void> refreshInvoices() async {
    await fetchAndStoreInvoices();
  }

}

import 'package:dio/dio.dart';
import 'package:flutter_application_1/controller/appController.dart';
import 'package:flutter_application_1/models.dart/compagnieModel.dart';
import 'package:flutter_application_1/models.dart/historiqueModel.dart';
import 'package:flutter_application_1/models.dart/saleModel.dart';
import 'package:flutter_application_1/services/Apiservice.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/models.dart/Item.dart';
import 'package:flutter_application_1/models.dart/category.dart';

class ApiController extends GetxController {
  static ApiController instance = Get.find();
  // Liste des catégories et des items
  final RxList<Category> categories = <Category>[].obs;
  final RxList<Item> items = <Item>[].obs;
  final RxList<Item> itemsRupture = <Item>[].obs;
  var historiques = <ActionItem>[].obs;
  var isCategorySelected = false.obs;
  var categorySelected = Category().obs;
  final RxList<Item> filteredItems = <Item>[].obs;
  final RxList<Category> filteredCategory = <Category>[].obs;
  final RxList<Item> itemsRupturefilter = <Item>[].obs;
  var isLoading = false
      .obs; // Variable pour indiquer si les données sont en train de se charger

  // Instance de ApiService
  final ApiService _apiService = ApiService();

  // Observable pour stocker les informations de l'entreprise et de l'utilisateur
  var companyUserInfo = CompanyUserInfo(
    companyName: '',
    companyLogo: '',
    userName: '',
  ).obs;

  // Fonction pour récupérer les informations de l'entreprise et de l'utilisateur
  Future<void> fetchCompanyUserInfo() async {
    try {
      isLoading.value = true;
      final response = await _apiService.fetchCompanyUserInfo();
      companyUserInfo.value = CompanyUserInfo.fromJson(response.data);
      isLoading.value = false; // Mettre à jour l'état de chargement
      // print(cop)
    } catch (e) {
      print('Erreur lors de la récupération des informations : $e');
    }
  }

  // Fonction pour récupérer les catégories
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final fetchedCategories = await _apiService.fetchCategories();
      // print(fetchedCategories.length);
      categories.assignAll(fetchedCategories);
    } catch (e) {
      print('Erreur lors de la récupération des catégories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://inventory-app-five-ebon.vercel.app'),
  );

  Future<void> fechAction() async {
    try {
      isLoading.value = true;
      final actionitem = await fetchActionItems();
      // print(actionitem.length);
      historiques.assignAll(actionitem);
    } catch (e) {
      print(e);
      isLoading.value = false;
    }
  }

  Future<List<ActionItem>> fetchActionItems() async {
    try {
      final response = await _dio.get('/items/history',
          options: Options(
            headers: {
              'Authorization':
                  'Bearer ${userinfo.authmodel.value.access_token}',
            },
          ));
      // print(response.data);
      List<ActionItem> actionItems = (response.data as List)
          .map((item) => ActionItem.fromJson(item))
          .toList();
      return actionItems;
    } catch (e) {
      print('An error has occured: $e');
      return [];
    }
  }

  Future<List<Item>> fechtRuptureItemslist() async {
    try {
      final response = await _dio.get('/items/low-stock',
          options: Options(
            headers: {
              'Authorization':
                  'Bearer ${userinfo.authmodel.value.access_token}',
            },
          ));
      List<Item> items = (response.data as List)
          .map((json) => Item(
                id: json['id'],
                name: json['name'],
                quantity: json['quantity'],
                unitPrice: json['unitPrice'],
                itemsTotal: json['itemsTotal'],
                createdAt: DateTime.parse(json['createdAt']),
                createdById: json['createdById'],
                updatedAt: json['updatedAt'] != null
                    ? DateTime.parse(json['updatedAt'])
                    : null,
                categoryId: json['categoryId'],
              ))
          .toList();
      return items;
    } catch (e) {
      throw Exception('An error has occured: $e');
    }
  }

  Future<void> fetchItems() async {
    try {
      isLoading.value = true;
      final fetchedItems = await _apiService.fetchItems();
      items.assignAll(fetchedItems);
    } catch (e) {
      print('An error has occured: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fechtRuptureItems() async {
    try {
      isLoading.value = true;
      final fechtRuptureItems = await fechtRuptureItemslist();
      itemsRupture.assignAll(fechtRuptureItems);
    } catch (e) {
      print('An error has occured: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Rafraîchissement global des catégories et des items
  Future<void> refreshData() async {
    await fetchCompanyUserInfo();
    await fetchCategories();
    await fetchItems();
    await fechAction();
    await fechtRuptureItems();
    await salesController.fetchTotalSales();
    await invoiceController.refreshInvoices();
    await deliveryController.getDeliveries();
    filteredItems.assignAll(items);
    filteredCategory.assignAll(categories);
    itemsRupturefilter.assignAll(itemsRupture);
  }
}

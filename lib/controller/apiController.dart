import 'package:dio/dio.dart';
import 'package:flutter_application_1/controller/appController.dart';
import 'package:flutter_application_1/models.dart/historiqueModel.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/models.dart/Item.dart';
import 'package:flutter_application_1/models.dart/category.dart';
import 'package:flutter_application_1/services/apiService.dart';

class ApiController extends GetxController {
  static ApiController instance=Get.find();
  // Liste des catégories et des items
  var categories = <Category>[].obs;
  var items = <Item>[].obs;
  var historiques = <ActionItem>[].obs;
  var isCategorySelected = false.obs;
  var categorySelected= Category().obs;
  var isLoading = false.obs; // Variable pour indiquer si les données sont en train de se charger

  // Instance de ApiService
  final ApiService _apiService = ApiService();

  // Fonction pour récupérer les catégories
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final fetchedCategories = await _apiService.fetchCategories();
      print(fetchedCategories.length);
      categories.assignAll(fetchedCategories);
    } catch (e) {
      print('Erreur lors de la récupération des catégories: $e');
    } finally {
      isLoading.value = false;
    }
  }
  final Dio _dio = Dio(
    BaseOptions(
        baseUrl: 'https://agricultural-stevana-softart-comp-fab2bc8e.koyeb.app'),
  );

Future<void> fechAction()async{
  try {
    isLoading.value = true;
    final actionitem=await fetchActionItems();
    print(actionitem.length);
    historiques.assignAll(actionitem);

  } catch (e) {
    print(e); 
    isLoading.value = false;
  }
}

Future<List<ActionItem>> fetchActionItems() async {
    try {
      final response = await _dio.get('/items/history',options: Options(
            headers: {
              'Authorization':
                  'Bearer ${userinfo.authmodel.value.access_token}',
            },
          ));
          print(response.data);
      List<ActionItem> actionItems = (response.data as List)
          .map((item) => ActionItem.fromJson(item))
          .toList();
      return actionItems;
    } catch (e) {
      print('Erreur lors de la récupération des données: $e');
      return [];
    }
  }

//  Future<void> fetchHistory() async {
//     try {
//       isLoading.value = true;
//        await _apiService.fetchItems();
//       print(fetchedCategories.length);
//       categories.assignAll(fetchedCategories);
//     } catch (e) {
//       print('Erreur lors de la récupération des catégories: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }
  // Fonction pour récupérer les items
  Future<void> fetchItems() async {
    try {
      isLoading.value = true;
      final fetchedItems = await _apiService.fetchItems();
      items.assignAll(fetchedItems);
    } catch (e) {
      print('Erreur lors de la récupération des items: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Rafraîchissement global des catégories et des items
  Future<void> refreshData() async {
    await fetchCategories();
    await fetchItems();
    await fechAction();
  }
}
